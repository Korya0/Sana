'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "0eae86c8f5737d322c475b975329cc5b",
"assets/AssetManifest.bin.json": "9f27f4d7385b8d102e696767f1be3c9b",
"assets/assets/audio/salat_ala_nabi_sound_1.mp3": "9d11268e0edc4ce9514c4e487189c1d2",
"assets/assets/data/daily_content.json": "6be5cb3790d189cd9ec247fbdc2b338b",
"assets/assets/fonts/cairo/Cairo-Black.ttf": "5e8d1abc73e3cb2f4e4f28e8f1266810",
"assets/assets/fonts/cairo/Cairo-Bold.ttf": "08f051a1822e014b22374926f1406d01",
"assets/assets/fonts/cairo/Cairo-ExtraBold.ttf": "5ce7df38518378257d6df38e39db5a6e",
"assets/assets/fonts/cairo/Cairo-ExtraLight.ttf": "4ebc824ed5df082492eceb0969893ab7",
"assets/assets/fonts/cairo/Cairo-Light.ttf": "8078edb223451b37ee9e678c3b4b2f73",
"assets/assets/fonts/cairo/Cairo-Medium.ttf": "700c074c00ff17e59cc58449cfb85e75",
"assets/assets/fonts/cairo/Cairo-Regular.ttf": "5dacd3d88fa294c5c6263d4041a34935",
"assets/assets/fonts/cairo/Cairo-SemiBold.ttf": "a847fd89b0c852cfaa85478f1ef88612",
"assets/assets/fonts/uthman/UthmanTN1-Ver10.otf": "7c0c99d532f135f63633578347912421",
"assets/assets/images/app_logo.png": "31a600898a007062f51c04a3987e0465",
"assets/assets/images/native_splash.png": "74200c0a75f8dd07eff6766ce9885db8",
"assets/assets/json/asma_ul_husna.json": "70eab9c120a0335adf0d396df782b419",
"assets/assets/json/azkar.json": "a3bff6e0e1ec0aa02714666ba64327e9",
"assets/assets/json/teaching_prayer.json": "2df117f1de368aee4b466e6269398c5a",
"assets/assets/svgs/app_logo.svg": "049d1fbfd46e39e9afa99a26e7d75843",
"assets/FontManifest.json": "bfc766a9e85a320fe2c4c1e625d5f23f",
"assets/fonts/MaterialIcons-Regular.otf": "a480d5f223823b01790da0a6ddcab349",
"assets/NOTICES": "bf3d652330a72362b4a99063c3b6a4f7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_islamic_icons/assets/fonts/IslamicIcons.ttf": "83caab3a2c2b140f80725df6ac6e80cc",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "628ae5d3e27b516421328f51d43627e6",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "19b488bd12b1a3ef6631bdbfdb68d71d",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "195c3cb5f66636c90005c6d09945bc6e",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "6ebc7bc5b74956596611c6774d8beb5b",
"assets/packages/media_kit/assets/web/hls1.4.10.js": "bd60e2701c42b6bf2c339dcf5d495865",
"assets/packages/quran_library/assets/en.json": "98cfca268ad6664481a03cecadca3137",
"assets/packages/quran_library/assets/fonts/Cairo-Bold.ttf": "ad486798eb3ea4fda12b90464dd0cfcd",
"assets/packages/quran_library/assets/fonts/Cairo-Medium.ttf": "2b76c14c6934874d64ab85d92c4949e1",
"assets/packages/quran_library/assets/fonts/Cairo-Regular.ttf": "5ccd08939f634db387c40d6b4b0979c3",
"assets/packages/quran_library/assets/fonts/Cairo-SemiBold.ttf": "e11b6bc7a07669209243fce5de153be4",
"assets/packages/quran_library/assets/fonts/Kufam-Regular.ttf": "552c74407616f42443ba1814761b9b3c",
"assets/packages/quran_library/assets/fonts/NotoNaskhArabic-VariableFont_wght.ttf": "ca8ba160f47026130c9d1804d914056f",
"assets/packages/quran_library/assets/fonts/surah-name-v4.ttf": "1592171eb6e08d0585ab2285b8d05239",
"assets/packages/quran_library/assets/fonts/surah_name_naskh.ttf": "75f99d39677c694876fa2bec2e4ad855",
"assets/packages/quran_library/assets/fonts/UthmanicHafs_V20.ttf": "32397346c04c8b1dcc2476d9fccf05e4",
"assets/packages/quran_library/assets/fonts/Uthmanic_NeoCOLORD-Regular.ttf": "1d6bbae8d48e5d63f5fa0d1de9af0d3b",
"assets/packages/quran_library/assets/fonts/vertopal.com_QCF_Bismillah-Regular.ttf": "53ea4ef49254f45b0ebee55763da0615",
"assets/packages/quran_library/assets/images/quran_library_logo.png": "02b789cc4ac644dc55e8ddbecf6347f5",
"assets/packages/quran_library/assets/jsons/quranV3.json": "9f4cdadb44124b927d1c12d58f573d98",
"assets/packages/quran_library/assets/jsons/quran_hafs.json": "de936c973bf0668af1d5b8f8f05e52cd",
"assets/packages/quran_library/assets/jsons/surahs_name.json": "ec192e1cfec6c935d1fd444b9140597b",
"assets/packages/quran_library/assets/saadi.json": "ad9eab189b790af56d414f54cd19e830",
"assets/packages/quran_library/assets/svg/alert.svg": "0b8fd7060d344bb2649249031fa18956",
"assets/packages/quran_library/assets/svg/ayahBookmarked.svg": "bf54058a7b677686ccf66cf84613f144",
"assets/packages/quran_library/assets/svg/backArrow.svg": "65fed04b482e5c34607b8df90ab02dee",
"assets/packages/quran_library/assets/svg/backward.svg": "8798154e214ebd7c83b7e193621a5f78",
"assets/packages/quran_library/assets/svg/buttomSheet.svg": "5e516bf9313adfa3fd33ce88bb5ca0ab",
"assets/packages/quran_library/assets/svg/checkMark.svg": "28ea36ea6ecccba35947a91c61d19738",
"assets/packages/quran_library/assets/svg/options.svg": "158fe14f1604247537041637515d76fa",
"assets/packages/quran_library/assets/svg/pauseArrow.svg": "dee8f8b93bc3fcd8b4fae418e9f89646",
"assets/packages/quran_library/assets/svg/playArrow.svg": "d35518e4fd923483ea31e16e41d19094",
"assets/packages/quran_library/assets/svg/rewind.svg": "0c5bc7553e003429e19145afa0450d8b",
"assets/packages/quran_library/assets/svg/sajdaIcon.svg": "9dca8c20d42f02a6be011b5f706dc120",
"assets/packages/quran_library/assets/svg/surahsAudio.svg": "7a67e81e67b794ab3611160a1be600a8",
"assets/packages/quran_library/assets/svg/surahSvgBanner.svg": "e513e5366083a1850371d87716bc2f42",
"assets/packages/quran_library/assets/svg/surahSvgBannerDark.svg": "47b84281f3120613514c299d3b56c7e3",
"assets/packages/quran_library/assets/svg/suraNum.svg": "a432b4668d01226f1f65d8b6cf470dc5",
"assets/packages/solar_icons/fonts/SolarIconsBold.ttf": "daabdb5a493f850960ab452d5413f3ce",
"assets/packages/solar_icons/fonts/SolarIconsBroken.ttf": "a581be9bb58e09542c5f22243b7ffa1a",
"assets/packages/solar_icons/fonts/SolarIconsOutline.ttf": "e3b79fe5e635281dd7e76a7dc85032b4",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shorebird.yaml": "76c772c21b134b30239238b866e4e22d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.ico": "72dc41a690fbe88acc24b5c12f2c400e",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "0cfecd38edca413d0cbf47e26a44174d",
"icons/apple-touch-icon.png": "0283d82115f6729e3e1144cc7acba197",
"icons/icon-192-maskable.png": "3ab3b037dda9df6b669ff3f8f018539d",
"icons/icon-192.png": "3ab3b037dda9df6b669ff3f8f018539d",
"icons/icon-512-maskable.png": "1f0de05c32c01ac88f64ac566b802456",
"icons/icon-512.png": "1f0de05c32c01ac88f64ac566b802456",
"index.html": "0c744d0d04bd13ed5160646d94a5cc0b",
"/": "0c744d0d04bd13ed5160646d94a5cc0b",
"main.dart.js": "70985e5c559ca7226e68fd9bf7938aa8",
"manifest.json": "9ca9cb9c610764ae42c04de2a3b55c2d",
"vercel.json": "abd07d5b81e7d2c7029cc5611e1ec638",
"version.json": "3dfdd086441e9ea5bcc9aa8a9e6243c4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
