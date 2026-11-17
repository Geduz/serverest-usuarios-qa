function fn() {
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 10000);
  karate.configure('report', { showLog: false });
  return { baseUrl: karate.properties['baseUrl'] || 'https://serverest.dev' };
}

