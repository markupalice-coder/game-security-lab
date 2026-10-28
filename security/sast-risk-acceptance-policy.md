# SAST Risk Acceptance Policy

## Purpose

This policy defines how the studio records temporary exceptions for SAST findings.

Risk acceptance must never be used to hide findings, bypass security review, or permanently ignore vulnerable code.

## Allowed Use

A SAST finding may be accepted temporarily only when:

1. The finding is understood.
2. The business reason is documented.
3. A compensating control is active.
4. An owner is assigned.
5. An expiry date is defined.
6. Review evidence is linked.

## Not Allowed

Risk acceptance must not be used for:

1. Exposed secrets.
2. Active exploitation.
3. Critical unauthenticated remote-code execution.
4. Payment, wallet, or player-data exposure without security leadership approval.
5. Permanent suppression without review.

## Required Evidence

Every accepted finding must include:

1. Scanner name.
2. Finding ID or alert link.
3. Severity.
4. Business reason.
5. Compensating control.
6. Owner.
7. Expiry date.
8. Review evidence.

## Approval Rule

A submitted risk acceptance request is not automatically approved.

A designated security reviewer must evaluate the finding, confirm that the compensating control is appropriate, and document the approval decision.

Accepted risks must remain visible and traceable. Approval does not automatically disable SAST scanning or suppress findings.

## Expiry Rule

Expired risk acceptance issues must be re-reviewed, fixed, or escalated.

An extension requires a new review, an updated expiry date, and documented approval.

## Gaming Studio Context

Game services often include matchmaking APIs, telemetry endpoints, game economy logic, patch delivery systems, and live-ops tooling.

Temporary acceptance may be realistic, but silent acceptance can damage player trust, expose studio infrastructure, or weaken anti-abuse controls.
