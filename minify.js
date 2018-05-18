const minify = require('minify');

minify('main.js', (error, data) => {
  if (error)
    return console.error(error.message);

  console.log(data);
});
