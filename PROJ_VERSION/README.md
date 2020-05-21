# Vending machine module implementation

#### Hardware
- [Terasic's DE10-Lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021)
- [4\*4 Matrix Keypad](https://learn.parallax.com/tutorials/language/propeller-c/propeller-c-simple-devices/read-4x4-matrix-keypad)

#### Abstract
This is a vending machine that accepts coins Dime, Quater and Dollar (with respect to buttons on the keypad). The user can choose from 5 different items with at most amount of 3. The 7-segment LEDs display the accumulate amount of money which the user has inserted. Also, the vending machine shows the return if the inserted coins exceeds the price. If the user press the cancel button, the vending machine will return whatever amount the user has inserted and jump back to the waiting state.

#### State Diagram
![state_diagram](https://github.com/letitbe0201/mini-vending-machine/blob/master/PROJ_VERSION/state_diagram.jpg)

### [Project Report](https://github.com/letitbe0201/mini-vending-machine/blob/master/PROJ_VERSION/Project%20Report.pdf)
Credit:
- Yang Liu
- Yida Chung
- Zaixin Mu