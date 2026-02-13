# AGRIVET – Project Overview

> **Document purpose**: This file captures the complete _project-level_ understanding of AGRIVET (what the product is, how it behaves, and why it exists).
> This is **NOT** a tech doc and **NOT** an API doc.
> It is written for _you as the developer_ so you never forget the product logic again.

---

## 1. What is AGRIVET?

AGRIVET is a **location-based agriculture marketplace** similar to **OLX**, but focused on **agriculture and rural trade**.

It is **NOT an e-commerce platform**.

There is:

-   ❌ No delivery
-   ❌ No platform-managed payments
-   ❌ No order lifecycle

AGRIVET’s job is only to **connect buyers and sellers directly**.

Buyers and sellers:

-   See listings
-   Contact each other directly
-   Negotiate price, delivery, and payment **offline**

AGRIVET acts only as a **discovery and visibility platform**.

---

## 2. Who uses AGRIVET?

There are **three types of actors**, but only **two types of users**.

### 2.1 Admin / Super Admin (Web only)

Admins use a **web dashboard**.

They do **NOT** sell or buy products.

Their role is **monitoring and control**, not approval.

Admins can:

-   Create and manage **representatives**
-   View all users
-   View all product listings (future)
-   Delete products if needed (future)
-   Monitor referral performance
-   Monitor payments (future)

Important:

-   Admins do **not approve users**

---

### 2.2 Users (Mobile App)

Every normal person is a **User**.

A user can:

-   Register an account
-   Browse listings
-   Contact sellers
-   **Also become a seller** by posting products

There is **NO separate seller account**.

A single user can:

-   Buy today
-   Sell tomorrow

Selling is just an **action**, not a role.

---

### 2.3 Representatives (No login)

Representatives are **not users**.

They:

-   Do **not** log in
-   Do **not** use the app

They exist **only for marketing & referral tracking**.

Representatives are:

-   Created by Admin
-   Assigned a unique **referral code**
-   Used to track user growth

---

## 3. Core Idea of the Platform

The platform solves one problem:

> **“How do farmers, buyers, and sellers discover each other easily?”**

AGRIVET solves this by:

-   Location-based listings
-   Direct contact details
-   In App Chat with buyer to seller or seller to buyer
-   No middlemen

The platform does **NOT**:

-   Guarantee transactions
-   Handle disputes
-   Control pricing

AGRIVET is a **connector**, not a marketplace operator.

---

## 4. What can be sold on AGRIVET?

AGRIVET is agriculture-focused, but flexible.

Examples:

-   Livestock (cow, goat, buffalo, poultry)
-   Pets
-   Seeds
-   Fertilizers
-   Animal feed
-   Farm equipment
-   Tools
-   Machinery
-   Harvested crops
-   Domestic or consumption products

Each listing belongs to a **user**, not a store.

---

## 5. Product Listing Rules (Future Scope)

When product features are added, these rules apply:

-   A user uploads:

    -   Images
    -   Optional short video (max ~20 sec)
    -   Price
    -   Description
    -   Location (auto) when uploading we take
    -   Address
    -   Contact details

-   Once uploaded:

    -   ❌ User cannot edit the product
    -   Admin approval is required

-   Admin can:

    -   View all products
    -   Delete products if not platform-friendly

---

## 6. Visibility & Duration Model

Product visibility is **time-bound**.

Flow:

1. Upload product details
2. Accept platform terms
3. Submit product details
4. Wait for admin approval
5. Pay platform fee (future)
6. Product goes live
7. Product is visible for **X days**
8. After expiry → product disappears (inactive) for activation again need to pay again

Rules:

-   Same fee for every product
-   Same duration per product
-   Re-upload requires paying again

(Duration and pricing will be configured by Admin later.)

---

## 7. Authentication Philosophy

Authentication is **strict and secure**.

### Admin Auth (Web)

-   Email + password
-   Cookie-based auth
-   Access token + refresh token

### User Auth (Mobile)

-   Email / mobile signup
-   OTP verification required
-   Tokens stored securely (no cookies)

Important rule:

> A user account is **NOT valid** until OTP is verified.

Unverified users:

-   Not Exist in DB
-   It is in Redis cache for 5 min
-   After otp varified users in DB

---

## 8. Referral & Representative System

This is a **marketing tracking system**, not MLM.

### Why referral exists?

Admin wants to know:

-   Which field representative brought users
-   How many users joined via each representative
-   Performance comparison

---

### How referral works

1. Admin creates a Representative
2. System auto-generates a referral code

    - Example: `AGV9F3K2`

3. Representative shares this code offline
4. User optionally enters referral code during signup

Rules:

-   Referral code is **optional**
-   Invalid referral codes are ignored silently
-   Signup is never blocked due to referral

---

### Referral attachment rules

-   Referral is attached **ONLY at signup**
-   Referral cannot be changed later
-   Referral cannot be added after signup

This ensures data integrity.

---

## 9. What Admin Can Measure (Even Before Products)

Even without products or payments, Admin can track:

-   Total users
-   Users per representative
-   Growth per representative

This allows early performance analysis.

---

## 10. What is NOT in Scope (Intentionally)

AGRIVET intentionally does **NOT** include:

-   Product delivery
-   Payment escrow
-   Ratings & reviews
-   Order tracking
-   Dispute resolution

These are consciously excluded to:

-   Keep platform simple
-   Reduce liability
-   Encourage direct negotiation

---

## 11. Final One-Line Summary

> **AGRIVET is a mobile-first, location-based agriculture discovery platform that connects buyers and sellers directly, with admin-controlled visibility and referral-based growth tracking — not an e-commerce system.**

---

_End of document._
