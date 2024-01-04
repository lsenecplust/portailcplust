extension StringExtension on String {
   bool get isAlphaNum => RegExp(r'^[0-9A-Za-z]*$').hasMatch(this);
   bool get isNumdec => RegExp(r'^[0-9]*$').hasMatch(this);
   bool get isOntSerial => startsWith('SMB');
   bool get isSerial => startsWith('N');
   bool get isMac =>isAlphaNum && RegExp(r'^([0-9A-Fa-f]{2}){6}$').hasMatch(this);
   //Atention les mac uniquement en chiffre ne seront pas reconnue
}