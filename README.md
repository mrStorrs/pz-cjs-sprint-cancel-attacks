# CJS Sprint Cancel Attacks

Allows pressing sprint during a weapon attack animation to cancel the attack before its hit frame.

The mod intentionally does not cancel shoves, stomps, or grapples because vanilla `SwipeStatePlayer.exit()` can apply stomp shoe/foot wear even when an attack collision has not happened yet.
