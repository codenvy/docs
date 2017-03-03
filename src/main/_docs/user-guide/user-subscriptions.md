---
tag: [ "codenvy" ]
title: Subscription and Billing
excerpt: ""
layout: docs
permalink: /:categories/subscriptions/
---
{% include base.html %}


You can purchase subscriptions for codenvy.io accounts from the user dashboard. Subscriptions allow you to have:  
- RAM: up to 30GB of RAM to run workspaces  
- Workspace timeout: 4 hours  
- Workspaces: Unlimited  

Subscriptions are charged when purchased and on the first of each following month (see [billing]({{base}}{{site.links["user-subscriptions"]}}#billing)).

# Billing

Paid subscriptions are charged at the time of purchase and renewals are charged at the beginning of each month. To calculate the charge when purchased we use the daily rate for the package the user has chosen and multiply that by the number of days remaining in the month (including the day of purchase).

Example:  
- **Initial purchase**: May 26th I buy a 1GB RAM package  
  - May 26, my credit card is charged $1.92 (6 x $0.32)  
  - June 1 and on the first of each month after, my credit card is charged $10  
- **Upgrade**: June 17 I buy another 1GB RAM package  
  - June 17, my credit card is charged $4.48 (14 x $0.32)  
  - July 1 and on the first of each month after, my credit card is charged $20  

If the credit card is removed or if the credit card cannot be charged all running workspaces will be stopped and the account resources will be moved back to the free tier level.  If the credit card can't be charged an email notification will be sent to the user warning them of the issue.

## Receipts

The following receipts are sent to paid subscription users:  
- **Transaction Receipt**: Sent as soon as the credit card is charged for a subscription.  
- **Monthly Subscription Summary**: Sent at the beginning of the month to any user with a credit card on file (even if it the user doesn't currently have a paid subscription). Users without a paid subscription will not be charged.  

# Billing in the Dashboard

## Subscription Status

You can view a summary of your subscriptions in the dashboard.

Click on your profile at the bottom of the left sidebar:  
![billing-access.png]({{base}}/docs/assets/imgs/codenvy/billing-access.png){:style="width: 30%"}

View a summary your account state:  
![billing-summary.png]({{base}}/docs/assets/imgs/codenvy/billing-summary.png)

## Buying RAM

From the "Billing" summary page, you are able to buy more RAM for your account.

Click on the button "Get More RAM". A new popup will be displayed:  
![billing-get-ram.png]({{base}}/docs/assets/imgs/codenvy/billing-get-ram.png)

If your billing information is not already registered, you will have to provide it:  
![billing-info-popup.png]({{base}}/docs/assets/imgs/codenvy/billing-info-popup.png)

Clicking "Continue" will purchase the subscription. Your card will be charged and you will immediately receive the requested additional RAM and a confirmation of the transaction.

## Update Billing information
You can update your billing information by going under the "Card" tab from billing page.

{% assign TODO="Update the image after merged" %}

## Invoices

You can download all your subscription invoices under the "Invoices" tab from billing page.

{% assign TODO="Update the image after merged" %}

## Cancel Subscription

To cancel a subscription, just remove your credit card information from your account. You can remove your credit card by going under the "Card" tab from billing page:

{% assign TODO="Update the image after merged" %}
