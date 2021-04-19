export class Logger {
  private logger = console;

  log(message?: any, ...optionalParams: any[]): void {
    if (optionalParams && optionalParams.length) {
      this.logger.debug(message, optionalParams);
    } else {
      this.logger.debug(message);
    }
  }

  info(message?: any, ...optionalParams: any[]): void {
    if (optionalParams && optionalParams.length) {
      this.logger.info(message, optionalParams);
    } else {
      this.logger.info(message);
    }
  }

  warn(message?: any, ...optionalParams: any[]): void {
    if (optionalParams && optionalParams.length) {
      this.logger.warn(message, optionalParams);
    } else {
      this.logger.warn(message);
    }
  }

  error(message?: any, ...optionalParams: any[]): void {
    if (optionalParams && optionalParams.length) {
      this.logger.error(message, optionalParams);
    } else {
      this.logger.error(message);
    }
  }
}

export default new Logger();
