import fs from 'fs';
import path from 'path';

import templateSetting from './src/environments/template-settings.json';

const outDir = './src/environments';
const settingJson = 'settings.json';

function updateSettings(settings: any) {
  settings.instrumentationKey = process.env.AI_INSTRUMENTATION_KEY;
}

function saveSettings(settings: any) {
  fs.writeFileSync(
    path.resolve('.', outDir, settingJson),
    JSON.stringify(settings, null, '  '),
    'utf8'
  )
}

updateSettings(templateSetting);
saveSettings(templateSetting);
