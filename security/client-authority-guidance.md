
# Client-Side Authority Guidance



Game clients may display inventory, request item grants, and show reward animations.



Game clients must not make final authoritative decisions for economy changes such as:

- granting items

- adding currency

- changing rank

- awarding XP

- unlocking paid content

- modifying marketplace ownership



The trusted server must validate the player, session, entitlement, anti-fraud context, and game rules before committing economy changes.



Lab 28 adds a Semgrep rule that flags suspicious client-side grant authority patterns for review.

