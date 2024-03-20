class Utility {
  Utility._();
  static final Utility instance = Utility._();
  int calculateCrc16(List<int> data) {
    const int polynomial = 0xA001;
    int crc = 0xFFFF;

    for (var byte in data) {
      crc ^= byte;
      for (int i = 0; i < 8; ++i) {
        if ((crc & 0x0001) != 0) {
          crc >>= 1;
          crc ^= polynomial;
        } else {
          crc >>= 1;
        }
      }
    }

    return crc & 0xFFFF;
  }

  //Read Coils on Modbus
  List<int> createReadCoilsMessage(
      int slaveId, int startAddress, int numberOfCoils) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(1); // Function code for "Read Coils"

    // Start address
    message.add(int.parse(
        (startAddress - 1).toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (startAddress - 1).toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Number of coils
    message.add(int.parse(
        numberOfCoils.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        numberOfCoils.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }

  //Read Discrete Inputs on Modbus
  List<int> createReadDiscreteInputsMessage(
      int slaveId, int startAddress, int numberOfInputs) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(2); // Function code for "Read Discrete Inputs"

    // Start address
    message.add(int.parse(
        (startAddress - 10001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (startAddress - 10001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(2, 4),
        radix: 16));

    // Number of inputs
    message.add(int.parse(
        numberOfInputs.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        numberOfInputs.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }

  //Read Multiple Holding Registers on Modbus
  List<int> createReadHoldingRegistersMessage(
      int slaveId, int startAddress, int numberOfRegisters) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(3); // Function code for "Read Multiple Holding Registers"

    // Start address
    message.add(int.parse(
        (startAddress - 40001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (startAddress - 40001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(2, 4),
        radix: 16));

    // Number of registers
    message.add(int.parse(
        numberOfRegisters.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        numberOfRegisters.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }

  //Read Input Registers on Modbus
  List<int> createReadInputRegistersMessage(
      int slaveId, int startAddress, int numberOfRegisters) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(4); // Function code for "Read Input Registers"

    // Start address
    message.add(int.parse(
        (startAddress - 30001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (startAddress - 30001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(2, 4),
        radix: 16));

    // Number of registers
    message.add(int.parse(
        numberOfRegisters.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        numberOfRegisters.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }

  //Write Single Coil on Modbus
  /*
  Example
  This command is writing the contents of discrete coil # 192 to OFF in the slave device with address 11.

  0B 05 00BF 0000 FC84

  0000: The status to write (FF00 = ON, 0000 = OFF).
  
  var message = createWriteSingleCoilMessage(11, 192, false);
  */
  List<int> createWriteSingleCoilMessage(
      int slaveId, int coilAddress, bool coilState) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(5); // Function code for "Write Single Coil"

    // Coil address
    message.add(int.parse(
        (coilAddress - 1).toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (coilAddress - 1).toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Coil state
    if (coilState) {
      message.add(0xFF);
      message.add(0x00);
    } else {
      message.add(0x00);
      message.add(0x00);
    }

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }

  //Write Single Holding Register on Modbus
  /* 
  Example:
  This command is writing the contents of analog output holding register # 40005 
  to the slave device with address 11. Each holding register can store 16 bits.

  0B 06 0004 ABCD 7604

  Data Part ↓
  ABCD: The value to write.

  var message = createWriteSingleRegisterMessage(11, 40005, 0xABCD);
  */
  List<int> createWriteSingleRegisterMessage(
      int slaveId, int registerAddress, int registerValue) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(6); // Function code for "Write Single Register"

    // Register address
    message.add(int.parse(
        (registerAddress - 40001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (registerAddress - 40001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(2, 4),
        radix: 16));

    // Register value
    message.add(int.parse(
        registerValue.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        registerValue.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }

  //Write Multiple Coils on Modbus
  /*
  Example:

  This command is writing the contents of a series of 9 discrete coils from #28 to #36(Excluded) to the slave device with address 11.
  0B 0F 001B 0009 02 4D01 6CA7

  Data Part ↓
  4D: Coils 35 - 28 (0100 1101)
  01: 7 space holders & Coil 36 (0000 0001)
  
  Message should be in this format 
  var message = createWriteMultipleCoilsMessage(11, 28, 9, [1, 0, 1, 0, 0, 1, 1, 0, 1].reversed.toList());
  */
  List<int> createWriteMultipleCoilsMessage(
      int slaveId, int startCoil, int numCoils, List<int> coilStates) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(15); // Function code for "Write Multiple Coils"

    // Start coil
    message.add(int.parse(
        (startCoil - 1).toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (startCoil - 1).toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Number of coils
    message.add(int.parse(
        numCoils.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        numCoils.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Byte count
    message.add((numCoils + 7) ~/ 8);

    // Coil states
    for (int i = 0; i < coilStates.length; i += 8) {
      int byte = 0;
      for (int bit = 0; bit < 8 && i + bit < coilStates.length; ++bit) {
        if (coilStates[i + bit] == 1) {
          byte |= 1 << bit;
        }
      }
      message.add(byte);
    }

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }
  //Write Multiple Holding Registers on Modbus
  /*
  Example:
  This command is writing the contents of two analog output holding registers # 40019 & 40020 
  to the slave device with address 11. Each holding register can store 16 bits.

  0B 10 0012 0002 04 0B0A C102 A0D5

  Data Part ↓
  0B0A: The value to write to register 40019
  C102: The value to write to register 40020
 
  var message = createWriteMultipleRegistersMessage(11, 40019, [0x0B0A, 0xC102]);
  */
  List<int> createWriteMultipleRegistersMessage(
      int slaveId, int startRegister, List<int> registerValues) {
    List<int> message = [];
    message.add(slaveId); // Slave ID
    message.add(16); // Function code for "Write Multiple Holding Registers"

    // Start register
    message.add(int.parse(
        (startRegister - 40001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(0, 2),
        radix: 16));
    message.add(int.parse(
        (startRegister - 40001)
            .toRadixString(16)
            .padLeft(4, '0')
            .substring(2, 4),
        radix: 16));

    // Number of registers
    message.add(int.parse(
        registerValues.length.toRadixString(16).padLeft(4, '0').substring(0, 2),
        radix: 16));
    message.add(int.parse(
        registerValues.length.toRadixString(16).padLeft(4, '0').substring(2, 4),
        radix: 16));

    // Byte count
    message.add(registerValues.length * 2);

    // Register values
    for (int value in registerValues) {
      message.add(int.parse(
          value.toRadixString(16).padLeft(4, '0').substring(0, 2),
          radix: 16));
      message.add(int.parse(
          value.toRadixString(16).padLeft(4, '0').substring(2, 4),
          radix: 16));
    }

    // Calculate CRC
    var crc = calculateCrc16(message);
    final checksum = crc.toRadixString(16).padLeft(4, '0');

    // Add CRC to the message
    message.add(int.parse(checksum.substring(2, 4), radix: 16));
    message.add(int.parse(checksum.substring(0, 2), radix: 16));

    return message;
  }
}
