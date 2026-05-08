// Heron Stables Service Worker — v1778284244
// Update this version number to force all clients to reload
const CACHE_VERSION = 'heron-v1778284244';
const CACHE_FILES = [
  '/heron-stables/',
  '/heron-stables/index.html',
  '/heron-stables/icon_1.jpg'
];

// Install: cache essential files
self.addEventListener('install', function(e) {
  self.skipWaiting(); // Activate immediately
  e.waitUntil(
    caches.open(CACHE_VERSION).then(function(cache) {
      return cache.addAll(CACHE_FILES);
    })
  );
});

// Activate: delete old caches
self.addEventListener('activate', function(e) {
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(
        keys.filter(function(key) { return key !== CACHE_VERSION; })
            .map(function(key) { return caches.delete(key); })
      );
    }).then(function() {
      return self.clients.claim(); // Take control immediately
    })
  );
});

// Fetch: network first, fall back to cache
self.addEventListener('fetch', function(e) {
  e.respondWith(
    fetch(e.request).then(function(response) {
      // Cache the fresh response
      var clone = response.clone();
      caches.open(CACHE_VERSION).then(function(cache) {
        cache.put(e.request, clone);
      });
      return response;
    }).catch(function() {
      // Offline fallback to cache
      return caches.match(e.request);
    })
  );
});
