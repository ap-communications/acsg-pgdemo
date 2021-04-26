import got from 'got';

export const download = (url: URL) => {
  return got.get(url);
}
