const apn = require('apn');
const { program } = require('commander');
require('dotenv').config({ path: 'vars.env' });

program
  .option('-t, --token <type>', 'token string')
  .option('-m, --message <type>', 'message string')
  .option('-b, --badge <number>', 'badge number', parseInt);

program.parse(process.argv);

const options = program.opts();

if (options.token) {
    if (options.message) {
        if (options.badge !== undefined) {
            var apnoptions = {
                token: {
                    key: process.env.APN_KEY_LOCATION,
                    keyId: process.env.APN_KEY_ID,
                    teamId: process.env.APN_TEAM_ID
                },
                production: false
            };
            var apnProvider = new apn.Provider(apnoptions);
            var note = new apn.Notification();
            note.expiry = Math.floor(Date.now() / 1000) + 7200; // Expires 2 hours from now.
            note.badge = options.badge;
            note.alert = options.message;
            note.topic = "charliegiannis.CarPass";
            apnProvider.send(note, options.token).then( (result) => {
                process.exit(0);
            });
        }
      }
}

