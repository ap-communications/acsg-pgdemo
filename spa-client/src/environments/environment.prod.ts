import settings from './settings.json';

export const environment = {
  production: true,
  instrumentationKey: settings.instrumentationKey,
  bffUrl: '/bff/greeting-tasks'
};
