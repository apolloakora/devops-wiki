
# LastPass Cli Use Cases

Pre-Conditions. Visit the How to Install LastPass CLI page and make sure you have a lastpass account and can login successfully with your LastPass Username and LastPass Master Password.

## LastPass Read Use Case | Create Secure Note in WebUI and read using LastPass CLI

Go to the lastpass website (or the lastpass browser plugin) and create a secure note in a new folder.

> Folder  : salary
> Note Id : john
> Note    : john's salary is 42,500 and he is eligible for a 10% bonus. Next review date is xmas 2020.

> Folder  : salary
> Note Id : mary
> Note    : mary's salary is 37,000 and she is doing the same job as john. No bonux. Need to address this asap.

### Show Salary Notes from the LastPass CLI

We have created 2 salary notes in a folder called "salary" - we want to use the LastPass command line interface to view these notes.

``` bash
lpass login abc123@gmail.com
lpass show salary/john
lpass show salary/mary
```

The lpass show command shows us the secure notes we typed in.
Note that `lpass show john` still produces the note but its better to use the "fully qualified" form to avoid ambiguity.


## LastPass Generate Use Case | Generate Credentials using LastPass CLI

Lastpass can generate credentials for you at the size you specify.

> lpass generate bigpassword 30
> Rr41Xx2D8H4cTz0Wmw-xKOfDpIhjTu

It gave you a strong 30 character credential **and stored it with the name bigpassword**.

More useful is the ability to create completely new account credentials. Typically six attributes are involved.

- **Url** &raquo; https://www.devopswiki.co.uk
- **Folder** &raquo; machines
- **Name** &raquo; laptop
- **Username** &raquo; joebloggs
- **Password** &raquo; p455w0rd

