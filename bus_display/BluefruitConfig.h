#define BUFSIZE         128     //Size of read buffer for incoming data
#define VERBOSE_MODE    true    //enables Verbose Debug output if true

//Set pins for software UART
#define BLUEFRUIT_SWUART_RXD_PIN       9    // Recieve Pin
#define BLUEFRUIT_SWUART_TXD_PIN       10   // Transmit Pin
#define BLUEFRUIT_UART_CTS_PIN         11   // Tells bluefruit it ok to send data to arduino.
#define BLUEFRUIT_UART_RTS_PIN         8    // Tell arduino its ok to send data to bluefruit. Optional, set to -1 if unused

//set some basic info for hardware UART.
#ifdef Serial1    // this makes it not complain on compilation if there's no Serial1
  #define BLUEFRUIT_HWSERIAL_NAME      Serial1
#endif


//Shared UART
#define BLUEFRUIT_UART_MODE_PIN        12    //Switches between ATCommand and UART modes.


//We left out the SPI pin settings because we have the UART breakout board.

//Configuration settings for bluefruit systems. 
#define FACTORYRESET_ENABLE         1  //if 1, resets bluefruit upon code upload, this means any glitches we made are cleared out. WARNING! CHANGE TO 0 PRIOR TO DEPLOYING PROJECT
#define MINIMUM_FIRMWARE_VERSION    "0.6.6" //checks to make sure some features are availble based on minimum firmware. 
#define MODE_LED_BEHAVIOUR          "MODE"  //What makes the led blink. Options are:
                                            //DISABLE, 
                                            //MODE (indicates module mode), 
                                            //BLEUART (Displays BLE UART Activity)
                                            //HWUART (displays HW UArt Activity), 
                                            //SPI (displays SPI activity, out module does not have this)
                                            //MANUAL (Manually control LED)
#define deviceName "CHS Bus Loop"    //name of the bluetooth system


