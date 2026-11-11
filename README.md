# containerless-polyglot-deployments

A production-grade reference repository demonstrating continuous integration (CI) and deployment (CD) pipelines for **non-containerized, host-native workloads**. 

This project intentionally avoids Docker/OCI containers, focusing instead on compiling, packaging, and deploying applications directly onto target operating systems, virtual machines, and bare-metal environments using native system managers (e.g., `systemd`) and artifact repositories.

## Runtime Architecture & Artifacts

| Runtime | Source Language | Build Tool / Compiler | Target Artifact | Deployment Mechanism |
| :--- | :--- | :--- | :--- | :--- |
| **Go** | Go | `go build` | Statically linked binary | `systemd` service |
| **Rust** | Rust | `cargo build --release` | Optimized native binary | `systemd` service |
| **C++** | C++ | `cmake` / `make` | Compiled executable | `systemd` service |
| **Java** | Java | Maven / Gradle | Executable `.jar` | `systemd` service (JRE host) |
| **Python** | Python | `pip` / `poetry` | Wheel (`.whl`) / Virtualenv bundle | Host virtual environment + proxy |
| **Node.js** | JavaScript | `npm pack` / tarball | Compressed runtime bundle | Host Node runtime + process manager |

## Workflow Overview
1. **CI Build:** Code is compiled or bundled into native distribution artifacts.
2. **Artifact Publishing:** Artifacts are pushed to immutable binary stores (Artifactory, Nexus, AWS S3, or GitLab/GitHub Package Registries).
3. **CD Deployment:** Deployment engines fetch raw artifacts, place them in host directories, update configurations, and trigger zero-downtime service reloads.
EOF