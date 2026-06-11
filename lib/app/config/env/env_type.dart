enum EnvType {
  dev,
  staging,
  prod;

  static EnvType fromString(String value) {
    switch (value) {
      case 'dev':
        return EnvType.dev;
      case 'staging':
        return EnvType.staging;
      case 'prod':
        return EnvType.prod;
      default:
        return EnvType.dev;
    }
  }
}
