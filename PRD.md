# Product Requirements Document

## Product Name

CopyVault

---

# Product Overview

CopyVault is a minimal Android application designed to store reusable text snippets and allow users to copy them quickly.

The application exists to eliminate repetitive typing and repeated searching for commonly used information.

Examples of stored content:

* LinkedIn URL
* GitHub URL
* Portfolio link
* Email address
* Professional presentation text
* Frequently used messages
* Code snippets

The application must prioritize speed and simplicity.

No unnecessary features should exist.

The main objective is instant access to reusable text.

---

# Main Problem

Users frequently reuse the same text multiple times during the day.

Searching through notes or messaging apps creates unnecessary friction.

The app solves this by centralizing reusable text and making copy actions immediate.

---

## tecnologies
sqflite

# Main Goal

Store reusable text.

Retrieve reusable text quickly.

Copy reusable text instantly.

Minimal interaction required.

---

# MVP Scope

The MVP includes only 4 actions:

Create text

View saved texts

Edit text

Copy text

Delete text

No additional features.

---

# User Stories

### Create text

As a user

I want to save reusable text

So I can access it later

---

### View texts

As a user

I want to see all my saved texts

So I can choose what I need

---

### Copy text

As a user

I want to copy text with one tap

So I can paste it immediately

---

### Edit text

As a user

I want to update stored text

So I can keep information updated

---

### Delete text

As a user

I want to remove unnecessary texts

So my list stays organized

---

# Application Screens

## Home Screen

Main screen.

Contains:

Search bar at top

List of saved texts

Floating action button to create text

Each item shows:

Title

Small preview of content

Copy button

Behavior:

Tap copy button → copies text instantly

Tap card → opens detail page

---

## Create Screen

Contains:

Title input

Content textarea

Save button

Fields:

Title is required

Content is required

---

## Detail Screen

Displays:

Title

Full content

Actions:

Copy

Edit

Delete

---

## Edit Screen

Same as create screen

Pre-filled values

Save updates

---

# Core Features

## Save text

User can save text locally.

Required fields:

Title

Content

---

## List texts

Show all saved texts.

Ordered by newest first.

---

## Search

Real-time filtering.

Search by:

Title

Content

Updates while typing.

No button required.

---

## Copy text

Copy content directly to device clipboard.

Must require only one tap.

After copying:

Show small feedback message.

Example:

Copied successfully

---

## Edit text

Update existing text.

---

## Delete text

Delete stored text.

Require confirmation.

Example:

Delete this text?

Cancel

Delete

---

# Data Model

Entity: Snippet

Fields:

id

title

content

created_at

updated_at

---

# Non Functional Requirements

App startup under 2 seconds

Offline only

No internet required

Local database storage

Smooth scrolling

Fast search

Low battery usage

Low memory usage

---

# Design Philosophy

Minimal interface

Fast access

Low friction

No unnecessary screens

Primary action is copy

User should copy content in maximum 2 taps

---

# Excluded Features

Categories

Tags

Favorites

Cloud sync

Authentication

Analytics

AI integration

Themes

Widgets

Biometric lock

Import/export

Notifications

Folders

History

Backup

---

# Technical Requirements

Android only

Offline first

Local database

Simple architecture

Future extensibility allowed

No backend server

No account system

---

# Main Product Principle

The application is not a note-taking app.

The application is a fast-access text storage system built around copy actions.
