// Heron Stables Service Worker
const CACHE_VERSION = 'heron-v2';
const CACHE_FILES = [
  '/heron-stables/',
  '/heron-stables/index.html',
  '/heron-stables/icon_1.jpg'
];

self.addEventListener('install', function(e) {
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE_VERSION).then(function(cache) {
    return cache.addAll(CACHE_FILES);
  }));
});

self.addEventListener('activate', function(e) {
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(keys.filter(function(k){ return k !== CACHE_VERSION; }).map(function(k){ return caches.delete(k); }));
    }).then(function(){ return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function(e) {
  // Only handle GET requests for same-origin files — never touch Supabase
  if (e.request.method !== 'GET') return;
  if (e.request.url.indexOf('supabase.co') !== -1) return;
  if (e.request.url.indexOf('googleapis.com') !== -1) return;

  e.respondWith(
    fetch(e.request).catch(function() {
      return caches.match(e.request);
    })
  );
});