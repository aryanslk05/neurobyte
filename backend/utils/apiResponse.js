const buildResponse = ({ success = true, message = '', data = null }) => ({
  success,
  message,
  data
});

module.exports = { buildResponse };

