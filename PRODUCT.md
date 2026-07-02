# Product

## Register

product

## Users

People who repeatedly reuse the same pieces of text throughout the day — developers, job seekers, and professionals sharing things like profile links, emails, or boilerplate messages. They reach for the app mid-task (mid-conversation, mid-application-form) and need the stored text in their clipboard in seconds, not a browsing session.

## Product Purpose

CopyVault eliminates repetitive typing and repeated searching across notes/messaging apps by centralizing reusable text snippets and making the copy action immediate. Success is measured by speed and friction: any snippet copyable in at most 2 taps, app usable in under 2 seconds from launch.

## Brand Personality

Calm, focused, precise. The interface should feel quiet and get out of the way — no decoration competing with the copy action, no ambiguity about what to tap.

## Anti-references

- Cluttered productivity/SaaS dashboards (stat tiles, multi-panel layouts, card-grid overload) — CopyVault has exactly one list and one primary action, it should never look like it has more going on than that.
- Note-taking apps (Notion/Evernote-style rich docs) — per the PRD's own principle, CopyVault is explicitly not a notes app; avoid rich-text/document visual language.

## Design Principles

- Copy is the product. Every screen and layout decision should protect the "copy in ≤2 taps" rule — never add navigation or friction in front of it.
- One thing per screen. No categories, tags, filters, or panels beyond what the PRD scopes (search + list + FAB on Home).
- Quiet by default. Calm/precise personality means restrained color and motion — reserve emphasis for the copy action and destructive confirmations.
- Respect the excluded-features list as a design constraint, not just a backlog note — resist decorative or structural additions that imply features that don't exist (e.g. no folder-like grouping, no favorite stars, no theme switcher).

## Accessibility & Inclusion

WCAG AA contrast minimum. Respect `prefers-reduced-motion` / platform reduce-motion settings for any transitions. No additional stated requirements.
