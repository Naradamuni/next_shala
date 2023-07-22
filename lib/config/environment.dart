const bool isProduction = bool.fromEnvironment('dart.vm.product');

///Development urls
const testConfig = {
  'baseUrl': 'http://api.nextshala.com',
};

///Production urls
const productionConfig = {
  'baseUrl': 'http://api.nextshala.com',
};

const environment = isProduction ? productionConfig : testConfig;
