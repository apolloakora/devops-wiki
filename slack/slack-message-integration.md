
# Slack Message Integrations

You can send slack messages using software and here are some nuggets of information.

## Gaining the Integration Slack Url

- go to slack web interface
- click on **Apps** (at the bottom of left hand menu)
- click **manage apps** (top left)
- click **Custom Integrations** on the small left hand Manage menu
- click on **Incoming Webhooks**
- either click **Add Configuration** on the left menu
- or select a configuration and click on the edit pencil

## Setting up the Integration

Fill out the fields and **copy the Webhook url**.

To really personalize it

- enter your full name in **Customize Name**
- select a mugshot (portrait) of yours truly for the **Customize Icon**

Now you are ready to test the integration.

## Curl to the Slack Rest API

The slack url you copied will look like this.

    https://hooks.slack.com/services/ABC1234ABC/XYZ5678XYZ/aBcD1234wXyZ

Now you can send hello world messages if you do not forget to replace the slack webhook url placeholders below.

### Send the Hello Slack World Message

```
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello Slack World!"}' <<Put-Slack-Webhook-Url-Here>>
curl -X POST --data-urlencode "payload={ \"text\": \"Hello Slack World\nAnd Goodbye\n\" }" <<Put-Slack-Webhook-Url-Here>>
```

### Slack Configuration Options | channel | username | icon_emoji

In the world of email **channel would be To:** and **username would be From:**. To avoid mistakes these are best set on the integration within Slack Console. Giving software less to worry about is usually a good thing.

However, if you want your software/scripts to control the To: and From: you can use the below. It sends to the **`#general`** channel pretending to be `**Joe Bloggs**` with a ghoulie emoji.

```
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"Joe Bloggs\", \"text\": \"Please do not be afraid - I am not from the afterlife\n\", \"icon_emoji\": \":ghost:\"}" <<Put-Slack-Url-Here>>
```

The above helps you reflect on

- setting the destination channel to one you have already setup
- setting a username (optional if set on integration screen)
- setting an emoji icon is optional if **Customize Icon** was done

## Slack Markdown Demo

This message below illustrates some slack markdown capabilities. You can't do html tables like normal markdown - but you can

- use bold and italics (surround with asterix and underscore)
- do blockquotes (start with single right angled bracket)
- put newlines with backslash n `\n`


```bash
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"Joe Bloggs\", \"text\": \"What to escape - |£$%^&*()-_+={}[]:@~;'#<>?,./\nDid the newline work.\n*How about bold.*\n_*Bold and Italics*_\n> Quoting a sentence\n> Quote one other sentence. Like this one. And this one - or even. That one.\nThat said we are programmers.\nWe want to tell it like it is.\nYou have to escape the damn backticks.\n    \`grep -Frn @web.url .\`\n\nHere is a list.\n1. wake up.\n2. brush teeth\n3. change.\n4. leave house\nTry again\n- wake up.\n- brush teeth\n- change.\n- leave house\nAlmost finally you &amp; you. &lt;&lt;awesome&gt;&gt;\n\nWhat is the message size limit, mate?\nTerraform is rubbish at daylight savings - it's UTC or nothing.\nThe date/time ~&gt;\nAs useful as an ashtray on a mountain bike.\n&lt;&apos; Try {date_long} this&gt;\n\", \"icon_emoji\": \":ghost:\"}" <<Put-Slack-Url-Here>>
```

You must
- send `&amp;` for an ampersand
- send `&lt;` and `&gt;` for the angle brackets

Look here for more detailed discussions on Slack's markdown capabilities

## Slack SDK Know How

Curl is great but it has its limits. There are plenty of SDK's for JavaScript (the slack UI is written in JQuery and Bootstrap), Java, Ruby, Python, Go plus a few in R and Scala.

- **[Great Ruby Slack SDK](https://github.com/slack-ruby/slack-ruby-client)**
- **[Excellent Ruby Slack Onboarding Tutorial](https://github.com/slackapi/Slack-Ruby-Onboarding-Tutorial)**

You can also integrate with slack through **Terraform**, **Ansible**, **Chef**, **Puppet**, **Kibana**, **Prometheus**, **DataDog**, **CloudWatch**, **Nagios**, **Jenkins**, **CodeShip**, **TravisCI**, **CircleCI** and more besides.
