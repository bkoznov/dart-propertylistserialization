import 'dart:typed_data';

import 'package:PropertyListSerialization/src/binarypropertylistreader.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

void main() {

  // Array

  test('emptyArray', () {
    var template = '62706c6973743030a008000000000000010100000000000000010000000'
        '0000000000000000000000009';
    var p = BinaryPropertyListReader(bytes(template));
    var o = p.parse();
    expect(o.runtimeType, <Object>[].runtimeType);
    var list = o as List<Object>;
    expect(list.length, 0);
  });

  test('filledArray', () {
    var template = '62706c6973743030aa0102030405060708090a1000223fc000002340040'
        '0000000000009084500010203044f1014000102030405060708090a0b0c0d0e0f10111'
        '21333c1e9fc3af0e000005f101b54686520636f77206a756d706564206f76657220746'
        '86520646f676f101f0100010100540068006500200063006f00770020006a0075006d0'
        '070006500640020006f007600650072002000740068006500200064006f00670102010'
        '30813151a2324252b424b690000000000000101000000000000000b000000000000000'
        '000000000000000aa';
    var p = BinaryPropertyListReader(bytes(template));
    var o = p.parse();
    expect(o.runtimeType, <Object>[].runtimeType);
    var list = o as List<Object>;
    expect(list.length, 10);
    expect(list[0], 0);
    expect(list[1], 1.5);
    expect(list[2], 2.5);
    expect(list[3], true);
    expect(list[4], false);
    expectByteData(list[5] as ByteData, makeData(5));
    expectByteData(list[6] as ByteData, makeData(20));
    expect(list[7], DateTime.utc(1890, DateTime.june, 25, 06, 45, 13));
    expect(list[8], 'The cow jumped over the dog');
    expect(list[9], '\u0100\u0101The cow jumped over the dog\u0102\u0103');
  });

  // Dict

  test('emptyDict', () {
    var template = '62706c6973743030d008000000000000010100000000000000010000000'
        '0000000000000000000000009';
    var p = BinaryPropertyListReader(bytes(template));
    var o = p.parse();
    expect(o.runtimeType, <String, Object>{}.runtimeType);
    var dict = o as Map<String, Object>;
    expect(dict.length, 0);
  });

  test('filledDict', () {
    var template = '62706c6973743030da0102030405060708090a0b0c0d0e0f10111213145'
        '664617461323056646f75626c6553696e745566616c736555757466313654646174655'
        '47472756555666c6f61745564617461355561736369694f10140001020304050607080'
        '90a0b0c0d0e0f101112132340040000000000001000086f101f0100010100540068006'
        '500200063006f00770020006a0075006d0070006500640020006f00760065007200200'
        '0740068006500200064006f00670102010333c1e9fc3af0e0000009223fc0000045000'
        '10203045f101b54686520636f77206a756d706564206f7665722074686520646f67081'
        'd242b2f353b40454b51576e77797abbc4c5cad00000000000000101000000000000001'
        '5000000000000000000000000000000ee';
    var p = BinaryPropertyListReader(bytes(template));
    var o = p.parse();
    expect(o.runtimeType, <String, Object>{}.runtimeType);
    var dict = o as Map<String, Object>;
    expect(dict.length, 10);
    expect(dict['int'], 0);
    expect(dict['float'], 1.5);
    expect(dict['double'], 2.5);
    expect(dict['true'], true);
    expect(dict['false'], false);
    expectByteData(dict['data5'] as ByteData, makeData(5));
    expectByteData(dict['data20'] as ByteData, makeData(20));
    expect(dict['date'], DateTime.utc(1890, DateTime.june, 25, 06, 45, 13));
    expect(dict['ascii'], 'The cow jumped over the dog');
    expect(dict['utf16'], '\u0100\u0101The cow jumped over the dog\u0102'
        '\u0103');
  });

  // String

  test('asciiString', () {
    expectString('', '62706c697374303050080000000000000101000000000000000100000'
        '000000000000000000000000009');
    expectString(' ', '62706c69737430305120080000000000000101000000000000000100'
        '00000000000000000000000000000a');
    expectString('The dog jumped over the moon','62706c69737430305f101c54686520'
        '646f67206a756d706564206f76657220746865206d6f6f6e0800000000000001010000'
        '00000000000100000000000000000000000000000027');
  });

  test('unicodeString', () {
    expectString('Ā', '62706c69737430306101000800000000000001010000000000000001'
        '0000000000000000000000000000000b');
    expectString('Āā', '62706c6973743030620100010108000000000000010100000000000'
        '000010000000000000000000000000000000d');
    expectString('ĀāThe cow jumped over the dogĂă', '62706c69737430306f101f0100'
        '010100540068006500200063006f00770020006a0075006d0070006500640020006f00'
        '7600650072002000740068006500200064006f00670102010308000000000000010100'
        '0000000000000100000000000000000000000000000049');
  });

  // int

  test('integer', () {
    // positive
    expectInteger(0, '62706c697374303010000800000000000001010000000000000001000'
        '0000000000000000000000000000a');
    expectInteger(1, '62706c697374303010010800000000000001010000000000000001000'
        '0000000000000000000000000000a');
    expectInteger(126, '62706c6973743030107e08000000000000010100000000000000010'
        '000000000000000000000000000000a');
    expectInteger(127, '62706c6973743030107f08000000000000010100000000000000010'
        '000000000000000000000000000000a');
    expectInteger(128, '62706c6973743030108008000000000000010100000000000000010'
        '000000000000000000000000000000a');
    expectInteger(254, '62706c697374303010fe08000000000000010100000000000000010'
        '000000000000000000000000000000a');
    expectInteger(255, '62706c697374303010ff08000000000000010100000000000000010'
        '000000000000000000000000000000a');
    expectInteger(256, '62706c6973743030110100080000000000000101000000000000000'
        '10000000000000000000000000000000b');
    expectInteger(32766, '62706c6973743030117ffe0800000000000001010000000000000'
        '0010000000000000000000000000000000b');
    expectInteger(32767, '62706c6973743030117fff0800000000000001010000000000000'
        '0010000000000000000000000000000000b');
    expectInteger(32768, '62706c69737430301180000800000000000001010000000000000'
        '0010000000000000000000000000000000b');
    expectInteger(65534, '62706c697374303011fffe0800000000000001010000000000000'
        '0010000000000000000000000000000000b');
    expectInteger(65535, '62706c697374303011ffff0800000000000001010000000000000'
        '0010000000000000000000000000000000b');
    expectInteger(65536, '62706c69737430301200010000080000000000000101000000000'
        '00000010000000000000000000000000000000d');
    expectInteger(2147483646, '62706c6973743030127ffffffe0800000000000001010000'
        '0000000000010000000000000000000000000000000d');
    expectInteger(2147483647, '62706c6973743030127fffffff0800000000000001010000'
        '0000000000010000000000000000000000000000000d');
    expectInteger(2147483648, '62706c697374303012800000000800000000000001010000'
        '0000000000010000000000000000000000000000000d');
    expectInteger(9223372036854775806, '62706c6973743030137ffffffffffffffe08000'
        '0000000000101000000000000000100000000000000000000000000000011');
    expectInteger(9223372036854775807, '62706c6973743030137fffffffffffffff08000'
        '0000000000101000000000000000100000000000000000000000000000011');

    // negative
    expectInteger(-1, '62706c697374303013ffffffffffffffff0800000000000001010000'
        '00000000000100000000000000000000000000000011');
    expectInteger(-127, '62706c697374303013ffffffffffffff8108000000000000010100'
        '0000000000000100000000000000000000000000000011');
    expectInteger(-128, '62706c697374303013ffffffffffffff8008000000000000010100'
        '0000000000000100000000000000000000000000000011');
    expectInteger(-129, '62706c697374303013ffffffffffffff7f08000000000000010100'
        '0000000000000100000000000000000000000000000011');
    expectInteger(-255, '62706c697374303013ffffffffffffff0108000000000000010100'
        '0000000000000100000000000000000000000000000011');
    expectInteger(-256, '62706c697374303013ffffffffffffff0008000000000000010100'
        '0000000000000100000000000000000000000000000011');
    expectInteger(-257, '62706c697374303013fffffffffffffeff08000000000000010100'
        '0000000000000100000000000000000000000000000011');
    expectInteger(-32767, '62706c697374303013ffffffffffff8001080000000000000101'
        '000000000000000100000000000000000000000000000011');
    expectInteger(-32768, '62706c697374303013ffffffffffff8000080000000000000101'
        '000000000000000100000000000000000000000000000011');
    expectInteger(-32769, '62706c697374303013ffffffffffff7fff080000000000000101'
        '000000000000000100000000000000000000000000000011');
    expectInteger(-65534, '62706c697374303013ffffffffffff0002080000000000000101'
        '000000000000000100000000000000000000000000000011');
    expectInteger(-65535, '62706c697374303013ffffffffffff0001080000000000000101'
        '000000000000000100000000000000000000000000000011');
    expectInteger(-65536, '62706c697374303013ffffffffffff0000080000000000000101'
        '000000000000000100000000000000000000000000000011');
    expectInteger(-2147483647, '62706c697374303013ffffffff800000010800000000000'
        '00101000000000000000100000000000000000000000000000011');
    expectInteger(-2147483648, '62706c697374303013ffffffff800000000800000000000'
        '00101000000000000000100000000000000000000000000000011');
    expectInteger(-2147483649, '62706c697374303013ffffffff7fffffff0800000000000'
        '00101000000000000000100000000000000000000000000000011');
    expectInteger(-9223372036854775807, '62706c69737430301380000000000000010800'
        '00000000000101000000000000000100000000000000000000000000000011');
    expectInteger(-9223372036854775808, '62706c69737430301380000000000000000800'
        '00000000000101000000000000000100000000000000000000000000000011');
  });

  // Real

  test('float', () {
    expectDouble(0.0, '62706c69737430302200000000080000000000000101000000000000'
        '00010000000000000000000000000000000d');
    expectDouble(1.0, '62706c6973743030223f800000080000000000000101000000000000'
        '00010000000000000000000000000000000d');
    expectDouble(2.5, '62706c69737430302240200000080000000000000101000000000000'
        '00010000000000000000000000000000000d');
    // Input was 987654321.12345, but due to lack of precision, output will
    // be 987654336.0
    expectDouble(987654336.0, '62706c6973743030224e6b79a3080000000000000101'
        '00000000000000010000000000000000000000000000000d');
    expectDouble(-1.0, '62706c697374303022bf80000008000000000000010100000000000'
        '000010000000000000000000000000000000d');
    expectDouble(-2.5, '62706c697374303022c020000008000000000000010100000000000'
        '000010000000000000000000000000000000d');
    // Input was -987654321.12345, but due to lack of precision, output will
    // be 987654336.0
    expectDouble(-987654336.0, '62706c697374303022ce6b79a308000000000000010'
        '100000000000000010000000000000000000000000000000d');

    expectDouble(0.0, '62706c69737430302300000000000000000800000000000001010000'
        '00000000000100000000000000000000000000000011');
    expectDouble(1.0, '62706c6973743030233ff00000000000000800000000000001010000'
        '00000000000100000000000000000000000000000011');
    expectDouble(2.5, '62706c69737430302340040000000000000800000000000001010000'
        '00000000000100000000000000000000000000000011');
    expectDouble(987654321.12345, '62706c69737430302341cd6f34588fcd360800000000'
        '00000101000000000000000100000000000000000000000000000011');
    expectDouble(-1.0, '62706c697374303023bff0000000000000080000000000000101000'
        '000000000000100000000000000000000000000000011');
    expectDouble(-2.5, '62706c697374303023c004000000000000080000000000000101000'
        '000000000000100000000000000000000000000000011');
    expectDouble(-987654321.12345, '62706c697374303023c1cd6f34588fcd36080000000'
        '000000101000000000000000100000000000000000000000000000011');
  });

  // boolean

  test('true', () {
    expectBoolean(true, '62706c697374303009080000000000000101000000000000000100'
        '000000000000000000000000000009');
  });

  test('false', () {
    expectBoolean(false, '62706c69737430300808000000000000010100000000000000010'
        '0000000000000000000000000000009');
  });

  // Date

  test('date', () {
    expectDate(DateTime.utc(1970, DateTime.january, 1, 12, 0, 0), '62706c697374'
        '303033c1cd278fe0000000080000000000000101000000000000000100000000000000'
        '000000000000000011');
    expectDate(DateTime.utc(1890, DateTime.june, 25, 06, 45, 13), '62706c697374'
        '303033c1e9fc3af0e00000080000000000000101000000000000000100000000000000'
        '000000000000000011');
    expectDate(DateTime.utc(2019, DateTime.november, 4, 14, 22, 59), '62706c697'
        '37430303341c1b835e1800000080000000000000101000000000000000100000000000'
        '000000000000000000011');
  });

  // Data

  test('data', () {
    expectData(0, '62706c697374303040080000000000000101000000000000000100000000'
        '000000000000000000000009');
    expectData(1, '62706c697374303041000800000000000001010000000000000001000000'
        '0000000000000000000000000a');
    expectData(2, '62706c697374303042000108000000000000010100000000000000010000'
        '000000000000000000000000000b');
    expectData(14, '62706c69737430304e000102030405060708090a0b0c0d0800000000000'
        '00101000000000000000100000000000000000000000000000017');
    expectData(15, '62706c69737430304f100f000102030405060708090a0b0c0d0e0800000'
        '0000000010100000000000000010000000000000000000000000000001a');
    expectData(16, '62706c69737430304f1010000102030405060708090a0b0c0d0e0f08000'
        '000000000010100000000000000010000000000000000000000000000001b');
    expectData(100, '62706c69737430304f1064000102030405060708090a0b0c0d0e0f1011'
        '12131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031323334'
        '35363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f5051525354555657'
        '58595a5b5c5d5e5f606162630800000000000001010000000000000001000000000000'
        '0000000000000000006f');
    expectData(1000, '62706c69737430304f1103e8000102030405060708090a0b0c0d0e0f1'
        '01112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031323'
        '33435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f5051525354555'
        '65758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f7071727374757677787'
        '97a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9'
        'c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbeb'
        'fc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e'
        '2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff00010203040'
        '5060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272'
        '8292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4'
        'b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6'
        'e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909'
        '192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b'
        '4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d'
        '7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9f'
        'afbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1'
        'd1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f4'
        '04142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f6061626'
        '36465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f8081828384858'
        '68788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a'
        '9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbc'
        'ccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeee'
        'ff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f10111'
        '2131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f30313233343'
        '5363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f50515253545556575'
        '8595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7'
        'b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9'
        'e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c'
        '1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e'
        '4e5e6e7000800000000000002010000000000000001000000000000000000000000000'
        '003f4');
  });
}

/// Converts a hex encoded string [template] and returns it as ByteData.

ByteData bytes(String template) {
  var list = hex.decoder.convert(template);
  var ulist = Uint8List.fromList(list);
  var buffer = ulist.buffer;
  return ByteData.view(buffer);
}

/// Generates a ByteData of [len] length, whose values increment from 0..length.
/// The values wrap at 255 back to 0.

ByteData makeData(int len) {
  var gen = ByteData(len);
  var v = 0;
  for (var i = 0; i < len; i++) {
    gen.setUint8(i, v);
    v++;
    if (v == 256) {
      v = 0;
    }
  }
  return gen;
}

/// Compares [actual] and [matcher] ByteData's for exact size and contents.

void expectByteData(ByteData actual, ByteData matcher) {
  expect(actual.lengthInBytes, matcher.lengthInBytes);
  for (var i = 0; i < actual.lengthInBytes; i++) {
    expect(actual.getUint8(i), matcher.getUint8(i));
  }
}

/// Decodes the plist hex encoded string [template] and compares the resulting
/// object as String [matcher].

void expectString(String matcher, String template) {
  var p = BinaryPropertyListReader(bytes(template));
  var o = p.parse();
  expect(true, o.runtimeType == String);
  var s = o as String;
  expect(s, matcher);
}

/// Decodes the plist hex encoded string [template] and compares the resulting
/// object as an int [matcher].

void expectInteger(int matcher, String template) {
  var p = BinaryPropertyListReader(bytes(template));
  var o = p.parse();
  expect(true, o.runtimeType == int);
  var i = o as int;
  expect(i, matcher);
}

/// Decodes the plist hex encoded string [template] and compares the resulting
/// object as a double [matcher].

void expectDouble(double matcher, String template) {
  var p = BinaryPropertyListReader(bytes(template));
  var o = p.parse();
  expect(true, o.runtimeType == double);
  var d = o as double;
  expect(d, matcher);
}

/// Decodes the plist hex encoded string [template] and compares the resulting
/// object as a boolean [matcher].

void expectBoolean(bool matcher, String template) {
  var p = BinaryPropertyListReader(bytes(template));
  var o = p.parse();
  expect(true, o.runtimeType == bool);
  var d = o as bool;
  expect(d, matcher);
}

/// Decodes the plist hex encoded string [template] and compares the resulting
/// object as a DateTime [matcher].

void expectDate(DateTime matcher, String template) {
  var p = BinaryPropertyListReader(bytes(template));
  var o = p.parse();
  expect(true, o.runtimeType == DateTime);
  var d = o as DateTime;
  expect(d, matcher);
}

/// Decodes the plist hex encoded string [template] and compares the resulting
/// object as a ByteData [matcher].

void expectData(int length, String template) {
  var p = BinaryPropertyListReader(bytes(template));
  var o = p.parse();
  var d = o as ByteData;
  var b = makeData(length);
  expectByteData(d, b);
}