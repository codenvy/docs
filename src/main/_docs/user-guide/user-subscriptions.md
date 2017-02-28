---
tag: [ "codenvy" ]
title: Subscription and Billing
excerpt: ""
layout: docs
permalink: /:categories/subscriptions/
---
{% include base.html %}

# Subscriptions in Codenvy

Codenvy's subscription allow you to:
- get more RAM resources
- and a better idle timeout configuration

By default, any user get a free tier.

## Free Tier subscription

Any user with an account on Codenvy.io gets a free tier subscription which provide:
- RAM: 3GB
- Ability to create any number of workspaces of any size.
- Workspace timeout: 10 minutes
- No usage limits

## Paid tiers subscription

Depending on your need, you might need more RAM resources than the one provided by the free tier, you might also want to get a better idle timeout configuration. Paid tiers subscription provide longer timeout and more RAM to your account.

Paid tier subscriptions are paid in advance and charged each month (see billing rules applied [here]({{base}}{{site.links["user-subscriptions"]}}#billing-rules)).

Paid tier subscription are allowing the following:
- RAM: up to 30GB
- Ability to create any number of workspaces of any size.
- Workspace timeout: 4 hours
- No usage limits

## Billing rules

Paid tier subscriptions are paid in advance and charged each month.

### At the time of the purchase or upgrade, we charge for portion of the month remaining
We use the daily rate for the package the user has chosen and multiply that by the number of days remaining in the month (including the day of purchase).
- **Initial purchase example**: May 26th I buy 1GB RAM package
  - May 26, my credit card is charged $1.92 (6*0.32)
  - At the start of each month until I cancel I am charged another $10
- **Same package upgrade**: June 17 I buy 1GB more
  - Jun 17, my credit card is charged $4.48 (14*0.32)
  - At the start of each month until I cancel I am charged another $20

### Credit Card removed or failed when charging
Either credit card is removed OR credit card fails at end of the month AND the account has paid tier subscription.

The system is stopping all workspaces which were currently running. If the credit card failed, the system is sending an email notification to the user.  

You are able to come back into the product, update your credit card information and restart your workspaces normally

## Billing Receipts

The system is sending the following receipts:
- **Transaction receipt**: sent as soon as their credit card is charged for a subscription
- **Monthly Subscription Summary**: sent at the beginning of the month when you have a credit card registered into the system. You'll be charge only if you have an active subscription.


## Subscription Status

You can get consult the state of your account's subscriptions and get a summary view.
Click on your profile at the bottom of the left sidebar:
![billing-access.png]({{base}}/docs/assets/imgs/codenvy/billing-access.png){:style="width: 80%; height: 80%"}

You'll get a summary your account state:
![billing-summary.png]({{base}}/docs/assets/imgs/codenvy/billing-summary.png)

## Buy more RAM

From the "Billing" summary page, you are able to but more RAM resources for your account.

Click on the button "Get More RAM". A new popup will be displayed:
![billing-get-ram.png]({{base}}/docs/assets/imgs/codenvy/billing-get-ram.png)

If your billing information are not already registered into the system, you'll be ask to provide your credit card and billing information:
![billing-info-popup.png]({{base}}/docs/assets/imgs/codenvy/billing-info-popup.png)

Once you have provide your credit card and billing information you'll not be asked about them anymore.

Click "Continue" button. Your transaction will be proceed and you'll be granted the requested RAM resources.
You'll also receive an email which will confirm the transaction.

## Update Billing information
You can update your billing information your subscription configuration by going under the "Card" tab from billing page.

<% assign TODO="Update the image after merged" %>

## Invoices

You can download all your invoices for your subscriptions by going under the "Invoices" tab from billing page.

<% assign TODO="Update the image after merged" %>

## Cancel subscription

To cancel subscriptions, just remove your credit card information from your account.
You can remove your credit card by going under the "Card" tab from billing page.

<% assign TODO="Update the image after merged" %>
