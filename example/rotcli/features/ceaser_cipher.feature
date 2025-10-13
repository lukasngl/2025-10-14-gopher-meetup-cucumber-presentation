Feature: Ceaser Cipher Encryption and Decryption

  Scenario: Encrypt a message using Caesar cipher
    When I run rotcli with shift value 13 and input:
      """
      HELLO WORLD
      """
    Then the output should be:
      """
      URYYB JBEYQ
      """
