function fn() {
  var uuid = Java.type('java.util.UUID').randomUUID().toString();
  return {
    nome: 'QA Karate',
    email: 'qa-' + uuid + '@example.com',
    password: 'qa-' + uuid.slice(0, 12),
    administrador: 'false'
  };
}
