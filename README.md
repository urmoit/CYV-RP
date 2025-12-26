# CYV RP Framework

A comprehensive custom FiveM server framework designed for role-playing servers, providing modular systems for player management, economy, and social interactions.

## Features

### Core Systems
- **Player Management**: Character creation, registration, and login system
- **Inventory System**: Item management with weight limits and metadata
- **Economy System**: Jobs, money transactions, and banking
- **Vehicle Management**: Ownership, garages, and customization
- **Housing System**: Property ownership, furniture, rentals, and buyable mansions
- **Business System**: Drug dealing operations, ownership, and management
- **Factions/Gangs**: Group management and territory control
- **Police System**: Law enforcement mechanics and wanted system
- **Custom Events**: Server-wide events and community activities

### Additional Features
- Shops and marketplaces
- Crafting system with recipes
- Skills and leveling system
- Admin/moderation tools
- Logging and analytics

## Architecture

The framework follows a modular architecture with clear separation between client, server, and shared components:

- `server/`: Server-side logic and database operations
- `client/`: Client-side UI and interactions
- `shared/`: Shared utilities and configurations
- `config/`: Framework configuration files

## Installation

1. Download the framework files
2. Place the framework folder in your FiveM server's resources directory
3. Ensure you have oxmysql installed and configured
4. Update the configuration files in `config/` with your server settings
5. Add `start cyv_rp_framework` to your server.cfg

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql) - MySQL database integration
- NativeUI or similar UI library (recommended)
- EssentialMode or custom base functions

## Configuration

Edit the files in the `config/` directory to customize:
- Database connection settings
- Framework parameters
- System toggles

## Development

The framework is developed in Lua following FiveM scripting conventions. Contributions are welcome - please follow the established code style and submit pull requests.

## License

This framework is released under the MIT License. See LICENSE file for details.

## Roadmap

The development roadmap outlines the high-level plan for implementing the framework's features. Key phases include:

- Completing inventory and economy systems with advanced features
- Implementing housing system including buyable mansions
- Adding business system for drug dealing and illegal operations
- Developing comprehensive UI components
- Testing, optimization, and deployment

For detailed roadmap, see [plans/roadmap.md](plans/roadmap.md).

## TODO List

Current development tasks are tracked in the TODO list. Major areas include:

1. **Phase 1**: Core Infrastructure - Establish the foundational structure and database setup
2. **Phase 2**: Essential Systems - Implement core player and economic mechanics
3. **Phase 3**: Advanced Features - Add complex systems like vehicles, housing, business, and factions
4. **Phase 4**: Specialized Systems - Integrate police and event management
5. **Phase 5**: UI Development - Create comprehensive user interfaces
6. **Phase 6**: Advanced Systems - Implement additional features like crafting and skills
7. **Phase 7**: Testing and Polish - Finalize with testing, optimization, and deployment

For full TODO list, see [plans/todo.md](plans/todo.md).

## Support

For support and questions, join our Discord server or create an issue on GitHub.