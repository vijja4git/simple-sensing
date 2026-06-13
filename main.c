#include "MS51_16K.h"
#include <stdint.h>

// Local bit aliases not currently present in the minimal MS51_16K.h.
// Remove either line here if the same alias is later added to the header.
__sbit __at(0x80 + 3) P03;  // P0.3: common fault LED enable DIP
__sbit __at(0x90 + 3) P13;  // P1.3: Channel 2 fault LED

// ======================================================
// MS51FB9AE DUAL-CHANNEL NAMUR SENSOR CONTROLLER
// 5V ADC reference, independent NO/NC selection per channel,
// and one common fault LED enable/disable DIP.
//
// CHANNEL 1
//     ADC input:     P1.7 / ADC_CH0
//     Sense output:  P1.0 / P10
//     Fault output:  P1.2 / P12
//     NO/NC DIP:     P0.0 / P00
//
// CHANNEL 2
//     ADC input:     P3.0 / ADC_CH1
//     Sense output:  P1.1 / P11
//     Fault output:  P1.3 / P13
//     NO/NC DIP:     P0.1 / P01
//
// COMMON
//     Fault LED enable/disable DIP: P0.3 / P03
//
// DIP WIRING
//     4.7k pull-up from DIP input pin to VDD
//     DIP switch connects input pin to GND
//
//     DIP open:   input reads 1
//     DIP closed: input reads 0
//
// NO/NC OPERATION
//     DIP open  / Normal / NO:
//         Object sensed      -> sense output ON
//         Object not sensed  -> sense output OFF
//
//     DIP closed / Reverse / NC:
//         Object sensed      -> sense output OFF
//         Object not sensed  -> sense output ON
//
// FAULT OPERATION
//     Sensor break/not connected -> channel sense output OFF,
//                                   channel fault LED solid ON
//     Short circuit              -> channel sense output OFF,
//                                   channel fault LED blinking
//     Common fault-mask DIP OFF  -> both fault LEDs forced OFF
//
// ADC ASSUMPTION
//     VREF = 5.0V
//     12-bit ADC = 0 to 4095
// ======================================================

// ======================================================
// ADC THRESHOLDS FOR 5V REFERENCE
//
// Sensor break/not connected:
//     0.00V to 0.02V -> 0 to 16 counts
//
// Object sensed:
//     0.03V to 0.55V -> 25 to 450 counts
//
// Sensor connected, not sensing:
//     above 0.55V to below 1.50V -> 451 to 1228 counts
//
// Short circuit:
//     1.50V and above -> 1229 counts and above
//
// Values in the small undefined gaps are treated as safe/default:
// sense output OFF and fault LED OFF.
// ======================================================

#define ADC_BREAK_MAX            16U
#define ADC_SENSE_MIN            25U
#define ADC_SENSE_MAX            450U
#define ADC_CONNECTED_MIN        451U
#define ADC_CONNECTED_MAX        1228U
#define ADC_SHORT_MIN            1229U

#define ADC_WINDOW_SAMPLES       16U

// Higher value = slower blinking.
#define FAULT_BLINK_WINDOWS      80U

#define LED_ON                   1U
#define LED_OFF                  0U

#define MODE_NORMAL_NO           0U
#define MODE_REVERSE_NC          1U

#define FAULT_LED_DISABLED       0U
#define FAULT_LED_ENABLED        1U

static uint16_t ch1_adc_avg = 0U;
static uint16_t ch2_adc_avg = 0U;

static uint8_t fault_blink_state = LED_OFF;
static uint8_t fault_blink_count = 0U;

// ======================================================
// SMALL LOOP DELAY
// ======================================================

void delay_loop_small(void)
{
    unsigned int i;

    for (i = 0; i < 300; i++)
    {
        __asm__("nop");
    }
}

// ======================================================
// GPIO INITIALIZATION
// ======================================================

void gpio_init(void)
{
    // P1.0 = Channel 1 sense output, push-pull.
    P1M1 &= ~(1U << 0);
    P1M2 |=  (1U << 0);

    // P1.1 = Channel 2 sense output, push-pull.
    P1M1 &= ~(1U << 1);
    P1M2 |=  (1U << 1);

    // P1.2 = Channel 1 fault output, push-pull.
    P1M1 &= ~(1U << 2);
    P1M2 |=  (1U << 2);

    // P1.3 = Channel 2 fault output, push-pull.
    P1M1 &= ~(1U << 3);
    P1M2 |=  (1U << 3);

    // P1.7 = Channel 1 ADC input, input-only.
    P1M1 |=  (1U << 7);
    P1M2 &= ~(1U << 7);

    // P3.0 = Channel 2 ADC input, input-only.
    P3M1 |=  (1U << 0);
    P3M2 &= ~(1U << 0);

    // P0.0 = Channel 1 NO/NC DIP, input-only.
    P0M1 |=  (1U << 0);
    P0M2 &= ~(1U << 0);

    // P0.1 = Channel 2 NO/NC DIP, input-only.
    P0M1 |=  (1U << 1);
    P0M2 &= ~(1U << 1);

    // P0.3 = common fault LED enable DIP, input-only.
    P0M1 |=  (1U << 3);
    P0M2 &= ~(1U << 3);

    // Disable digital input receivers on ADC_CH0 and ADC_CH1.
    AINDIDS |= 0x03U;

    P10 = LED_OFF;
    P11 = LED_OFF;
    P12 = LED_OFF;
    P13 = LED_OFF;
}

// ======================================================
// ADC INITIALIZATION
// ======================================================

void adc_init(void)
{
    ADCCON1 |= 0x01U;
    ADCCON0 &= ~0x80U;
}

// ======================================================
// ADC READ
// ======================================================

uint16_t read_adc_channel(uint8_t channel)
{
    uint16_t result;

    // Select ADC channel while preserving the upper control bits.
    ADCCON0 &= 0xF0U;
    ADCCON0 |= (channel & 0x0FU);

    // Dummy conversion is used because the firmware switches between
    // ADC_CH0 and ADC_CH1. This allows the ADC sample capacitor to settle.
    ADCCON0 &= ~0x80U;
    ADCCON0 |=  0x40U;

    while ((ADCCON0 & 0x80U) == 0U)
    {
    }

    // Real conversion.
    ADCCON0 &= ~0x80U;
    ADCCON0 |=  0x40U;

    while ((ADCCON0 & 0x80U) == 0U)
    {
    }

    result = ((uint16_t)ADCRH << 4) |
             (ADCRL & 0x0FU);

    return result;
}

void read_adc_averages(void)
{
    uint8_t i;
    uint16_t ch1_sum;
    uint16_t ch2_sum;

    ch1_sum = 0U;
    ch2_sum = 0U;

    for (i = 0U; i < ADC_WINDOW_SAMPLES; i++)
    {
        ch1_sum += read_adc_channel(0U);
        ch2_sum += read_adc_channel(1U);
    }

    ch1_adc_avg = ch1_sum / ADC_WINDOW_SAMPLES;
    ch2_adc_avg = ch2_sum / ADC_WINDOW_SAMPLES;
}

// ======================================================
// DIP SWITCH READS
// ======================================================

uint8_t ch1_reverse_mode_enabled(void)
{
    // Active-low: P00 = 0 means Reverse / NC mode.
    return (P00 == 0U) ? MODE_REVERSE_NC : MODE_NORMAL_NO;
}

uint8_t ch2_reverse_mode_enabled(void)
{
    // Active-low: P01 = 0 means Reverse / NC mode.
    return (P01 == 0U) ? MODE_REVERSE_NC : MODE_NORMAL_NO;
}

uint8_t fault_leds_enabled(void)
{
    // Active-low mask DIP:
    // P03 = 1 -> fault LEDs enabled
    // P03 = 0 -> both fault LEDs disabled
    return (P03 == 0U) ? FAULT_LED_DISABLED : FAULT_LED_ENABLED;
}

// ======================================================
// VOLTAGE CLASSIFICATION
// ======================================================

uint8_t sensor_break_detected(uint16_t adc_value)
{
    return (adc_value <= ADC_BREAK_MAX) ? 1U : 0U;
}

uint8_t object_detected(uint16_t adc_value)
{
    return ((adc_value >= ADC_SENSE_MIN) &&
            (adc_value <= ADC_SENSE_MAX)) ? 1U : 0U;
}

uint8_t sensor_connected_not_sensing(uint16_t adc_value)
{
    return ((adc_value >= ADC_CONNECTED_MIN) &&
            (adc_value <= ADC_CONNECTED_MAX)) ? 1U : 0U;
}

uint8_t short_circuit_detected(uint16_t adc_value)
{
    return (adc_value >= ADC_SHORT_MIN) ? 1U : 0U;
}

// ======================================================
// MAIN SENSE OUTPUT CONTROL
// ======================================================

uint8_t calculate_sense_output(uint16_t adc_value, uint8_t reverse_mode)
{
    // Faults always force the sense output OFF.
    if ((short_circuit_detected(adc_value) != 0U) ||
        (sensor_break_detected(adc_value) != 0U))
    {
        return LED_OFF;
    }

    if (object_detected(adc_value) != 0U)
    {
        return (reverse_mode != 0U) ? LED_OFF : LED_ON;
    }

    if (sensor_connected_not_sensing(adc_value) != 0U)
    {
        return (reverse_mode != 0U) ? LED_ON : LED_OFF;
    }

    // Unknown transition gap: safe/default output OFF.
    return LED_OFF;
}

void update_sense_outputs(void)
{
    P10 = calculate_sense_output(ch1_adc_avg,
                                 ch1_reverse_mode_enabled());

    P11 = calculate_sense_output(ch2_adc_avg,
                                 ch2_reverse_mode_enabled());
}

// ======================================================
// FAULT OUTPUT CONTROL
// ======================================================

void update_fault_blink_tick(void)
{
    if (fault_blink_count < FAULT_BLINK_WINDOWS)
    {
        fault_blink_count++;
    }
    else
    {
        fault_blink_count = 0U;
        fault_blink_state = (fault_blink_state == LED_OFF) ? LED_ON : LED_OFF;
    }
}

uint8_t calculate_fault_output(uint16_t adc_value)
{
    if (short_circuit_detected(adc_value) != 0U)
    {
        return fault_blink_state;
    }

    if (sensor_break_detected(adc_value) != 0U)
    {
        return LED_ON;
    }

    return LED_OFF;
}

void update_fault_outputs(void)
{
    uint8_t ch1_short;
    uint8_t ch2_short;

    if (fault_leds_enabled() == FAULT_LED_DISABLED)
    {
        fault_blink_count = 0U;
        fault_blink_state = LED_OFF;
        P12 = LED_OFF;
        P13 = LED_OFF;
        return;
    }

    ch1_short = short_circuit_detected(ch1_adc_avg);
    ch2_short = short_circuit_detected(ch2_adc_avg);

    // Advance one shared blink clock if either channel is shorted.
    if ((ch1_short != 0U) || (ch2_short != 0U))
    {
        update_fault_blink_tick();
    }
    else
    {
        fault_blink_count = 0U;
        fault_blink_state = LED_OFF;
    }

    P12 = calculate_fault_output(ch1_adc_avg);
    P13 = calculate_fault_output(ch2_adc_avg);
}

// ======================================================
// MAIN
// ======================================================

void main(void)
{
    gpio_init();
    adc_init();

    P10 = LED_OFF;
    P11 = LED_OFF;
    P12 = LED_OFF;
    P13 = LED_OFF;

    while (1)
    {
        read_adc_averages();

        update_sense_outputs();
        update_fault_outputs();

        delay_loop_small();
    }
}