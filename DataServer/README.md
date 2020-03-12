# Data Server
This is the server that deals with storing and handling persistent data, also deals with
user registration and email sending.

## Dependencies
 * Node js 
 * MongoDB

---

### Settings.ini

#### application.secret
Set a random string here, this is used to add with the password salt.

#### application.port
The port where the data server will run on.

#### nodemailer
Mailing configuration, those params goes to the nodemailer plugin, the system sends emails to confirm
passwords and other kinds of stuff.
To see all the settings for this option, please check out the [nodemailer documentation](https://nodemailer.com/smtp/).
For testing purpposes I recommend using mailtrap.io.

#### mongodb.address
The full mongodb url, containing user and password to access it, with the database name attached to it.

**Example:**

```ini
[mongodb]
address = mongodb://localhost:27017/mercadinho
```