import * as path from 'path';
import * as fs from 'fs';
import { test, expect } from 'vitest';
import { DOMParser } from 'linkedom';
import { getAtomEntries } from '../../src/lib/get-atom-entries';

const parser = new DOMParser();

const atomPath = path.resolve(__dirname, '../fixture/atom.xml');
const atomXml = fs.readFileSync(atomPath, 'utf-8');
const atomDoc = parser.parseFromString(atomXml, 'text/xml');
const emptyAtomDoc = parser.parseFromString('<feed></feed>', 'text/xml');
const emptyRandomDoc = parser.parseFromString('<hello></hello>', 'text/xml');

const atomEntry = {
  url: 'atom-url',
  title: 'atom-title',
  published: 'atom-published'
};

test('should handle atom feeds', () => {
  const entries = getAtomEntries(atomDoc);
  expect(entries).toEqual([atomEntry, atomEntry]);
});

test('should return no atom feed entries if there are none', () => {
  const entries = getAtomEntries(emptyAtomDoc);
  expect(entries).toEqual([]);
});

test('should return no atom feed entries if the document is not an atom document', () => {
  const entries = getAtomEntries(emptyRandomDoc);
  expect(entries).toEqual([]);
});
