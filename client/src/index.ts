import argv from 'argv';
import { isNumber } from 'util';

import { download } from './download'
import logger from './utils/logger';

const MAXIMUN_NUM_OF_DOWNLOAD = 20;
const parseMaxDownload = (n: number) => {
  if (typeof n !== 'number' || n < 1 || MAXIMUN_NUM_OF_DOWNLOAD < n) {
    return MAXIMUN_NUM_OF_DOWNLOAD;
  }
  return n;
}

const range = (start: number, end: number) => Array.from({length: (end - start+ 1)}, (v, k) => k + start);
const delay = (ms: number) => new Promise<void>(resolve => setTimeout(() => resolve(), ms));
const random = (ms: number) => Math.floor(Math.random() * Math.floor(ms));

argv.type('URL', v => new URL(v));
const args = argv.option([
  {
    name: 'num',
    short: 'n',
    type: 'int',
    description: 'How many times to download'
  },
  {
    name: 'url',
    short: 'u',
    type: 'URL',
    description: 'Download url'
  }
]).run();

const url = args.options['url'] || new URL('http://localhost:3000/apis/slow');
const numOfDownload: number = parseMaxDownload(args.options['num']);

const promises: Promise<any>[] = [];
range(1, numOfDownload).map(i => {
  promises.push(
    delay(random(4567)).then(() => download(url)
    .then(res => JSON.parse(res.body))
    .then(json => logger.info(`completed ${i} greeting cache ${json.greeting.hasCache} task cache ${json.tasks.hasCache}`))
    .catch(e => logger.info(`error ${i} ${e}`)))    
  );
})
Promise.all(promises);
