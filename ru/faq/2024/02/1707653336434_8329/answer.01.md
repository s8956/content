Для правильной работы терминала {{< tag "PuTTY" >}} / {{< tag "KiTTY" >}} в {{< tag "BSD" >}} / {{< tag "Linux" >}}, у меня установлены следующие значения:

- Terminal
  - Keyboard
    - The Function keys and keypad, выбрать **Linux**.
- Windows
  - Translation
    - Remote character set, выбрать **UTF-8**.
- Windows
  - Translation
    - Включить **Enable VT100 line drawing even in UTF-8 mode**.
- Connection
  - Data
    - Terminal-type string, указать `putty`.
