## Contact

For audits, custom UUPS systems, or security reviews:

📧 Email: GlobalInvariantLabs@proton.me
🔐 PGP available on request

Serious inquiries only.
Smart-contract security & UUPS upgradeability.
Contact: GlobalInvariantLabs@proton.me

# uups-secure-starter

Audit-ready **UUPS upgradeable Solidity** starter focused on correctness, safety, and long-term maintainability.

This repository provides a minimal but hardened baseline for projects that require:
- upgradeability (UUPS)
- explicit role separation
- predictable storage layouts
- audit-friendly structure



## Scope

This starter is intentionally conservative.

It prioritizes:
- correctness over convenience
- explicitness over magic
- safety over gas micro-optimizations

Included patterns are suitable for production systems that will undergo external audit.



## Features

- UUPS upgradeability with explicit authorization
- Role-based access control (admin / upgrader separation)
- Pausable execution paths
- Explicit storage layout discipline
- Event-driven state changes
- Test scaffolding focused on invariants and upgrade safety



## Non-goals

This repository does **not** aim to:
- provide a full application framework
- abstract away upgrade mechanics
- hide complexity behind macros
- optimize for inexperienced users

It is designed for teams who understand the risks of upgradeable systems.



## Intended usage

This starter can be used as:
- a baseline for new protocols
- a reference for upgrading legacy contracts
- a review target for audit preparation
- a comparison point for custom architectures


## Security notes

Upgradeability introduces permanent risk.

Before using this code in production, you should:
- understand UUPS failure modes
- define clear upgrade governance
- lock or burn upgrade paths where appropriate
- subject all


## Quick start (Foundry)

Install dependencies:
- OpenZeppelin upgradeable contracts

Commands:
```bash
forge init
forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge test -vvv
