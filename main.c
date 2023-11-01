/* main.c: sample program for STM32H563
 * Copyright (C) 2023 Mete Balci

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include <stdbool.h>

// because STM32H563 is defined in Makefile
// this file will include stm32h563xx.h
#include <stm32h5xx.h>

// marked as used not to be removed by gcc
// this will be in .bss, check with readelf -a main.o
static uint8_t uvar __attribute__((used));

// marked as used not to be removed by gcc
// this will be in .data, check with readelf -a main.o
static uint8_t ivar __attribute__((used)) = 5;

// system_init is called very early from startup
// configure power and clock here
void system_init(void) 
{
  // on STM32H563
  // HSI is 64 MHz
  // after reset, HSIDIV is /2
  // SYSCLK is HSI after reset, thus 32 MHz (64/2)
  // HCLK is SYSCLK after reset (HPRE is set as HCLK=SYSCLK after reset)
  // SYSTICK external is fed by HCLK/8 after reset, thus 4 MHz (32/8)
}

// a simple systick implementation for timeinms counter
static volatile uint32_t timeinms = 0;

// this name is used in the vector table for systick exception
void SysTick_Handler(void)
{
  timeinms++;
}

void setup_systick(void) 
{
  // if clksource = external, then hclk/8 is used for systick
  // then LOAD should be 32MHz/8/1000, 4000 for every ms
  // if clksource = processor, then sysclk is used for systick
  // then LOAD should be 32MHz/1000, 32000 for every ms
  SysTick->LOAD = 32000;
  // set current value to 0
  SysTick->VAL = 0;
  // bit 2 = clksource = processor (set to 0 for external)
  // bit 1 = systick exception generation enabled
  // bit 0 = systick counter enabled
  SysTick->CTRL = 0b111;
}

void setup_pin_for_led(GPIO_TypeDef* const gpio, uint8_t pin)
{
	const uint32_t output_mode 	= 1; // general purpose
	const uint32_t output_type 	= 0; // push-pull
	const uint32_t output_speed = 2; // high speed
	const uint32_t pull_up_down = 0; // none
                                   //
	const uint32_t mask 			= (1UL << pin);
	const uint32_t twobitmask = (3UL << (pin<<1));

	MODIFY_REG(gpio->MODER,   twobitmask, output_mode << (pin<<1));
	MODIFY_REG(gpio->OTYPER,  mask,       output_type << pin);
	MODIFY_REG(gpio->OSPEEDR, twobitmask, output_speed << (pin<<1));
	MODIFY_REG(gpio->PUPDR,   twobitmask, pull_up_down << (pin<<1));
}

void inline turn_led_on(GPIO_TypeDef* const gpio, uint8_t pin)
{
  gpio->BSRR = (1UL << pin);
}

void inline turn_led_off(GPIO_TypeDef* const gpio, uint8_t pin)
{
  gpio->BSRR = (1UL << (pin+16));
}

void inline flip_led(GPIO_TypeDef* const gpio, uint8_t pin)
{
  if (gpio->ODR & (1UL << pin)) {
    turn_led_off(gpio, pin);
  } else {
    turn_led_on(gpio, pin);
  }
}

int main(void) 
{
  // led pins
	const uint8_t red_led_pin 	  = 4; //PG4
	const uint8_t yellow_led_pin 	= 4; //PF4
	//const uint8_t green_led_pin 	= 0; //PB0

  // led gpio ports
	GPIO_TypeDef* const red_led_gpio    = GPIOG;
	GPIO_TypeDef* const yellow_led_gpio = GPIOF;
	//GPIO_TypeDef* const green_led_gpio = GPIO_PORT('B');

	// enable GPIO port clocks of G, F
	RCC->AHB2ENR |= 0b1100000;

  // setup pins
  setup_pin_for_led(red_led_gpio,     red_led_pin);
  setup_pin_for_led(yellow_led_gpio,  yellow_led_pin);

  turn_led_on(red_led_gpio, red_led_pin);

  setup_systick();

  uint32_t lastms = timeinms;

  while (1) {

    if ((timeinms - lastms) > 1000) {
      lastms = timeinms;
      flip_led(yellow_led_gpio, yellow_led_pin);
    }

  }

  return 0;

}
