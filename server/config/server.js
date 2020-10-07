module.exports = ({ env }) => ({
  host: env('HOST', '192.168.1.7'),
  port: env.int('PORT', 1337),
  admin: {
    auth: {
      secret: env('ADMIN_JWT_SECRET', '9ecf93d95844815cfb74945de15bb130'),
    },
  },
});
