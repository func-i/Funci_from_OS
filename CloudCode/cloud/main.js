var Config = require('cloud/config');

Parse.Cloud.beforeSave(Parse.User, function(request, response) {
  if (request.object.get("ownerCode") != Config.ownerCode) {
    response.error("We're sorry, you must be the owner to edit this site.");
  } else {
    response.success();
  }
});