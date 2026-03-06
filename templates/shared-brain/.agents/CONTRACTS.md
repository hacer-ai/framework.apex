# CONTRACTS.md

Document only stable interfaces that affect multiple modules or teams.
When a contract changes, update the Change Log and notify all listed consumers before shipping.

## APIs
| Name | Input | Output | Owner | Consumers | Notes |
| --- | --- | --- | --- | --- | --- |
| [endpoint or contract] | [shape] | [shape] | [team/module] | [teams/modules] | [constraints] |

<!-- Ejemplo:
| POST /api/v1/payments/charge | `{ amount, currency, user_id }` | `{ charge_id, status }` | billing-service | checkout-ui, mobile | Breaking changes require 2-sprint notice |
-->

## Shared Types / Events
| Contract | Producer | Consumer | Notes |
| --- | --- | --- | --- |
| [name] | [module] | [module] | [compatibility notes] |

<!-- Ejemplo:
| UserCreatedEvent | auth-service | notifications, analytics | Schema frozen; extend only, never remove fields |
-->

## Change Log
| Date | Contract | Change | Breaking | Author | PR / Migration |
| --- | --- | --- | --- | --- | --- |
| YYYY-MM-DD | [name] | [what changed] | Yes / No | [Nombre / Claude / Codex] | [link] |
