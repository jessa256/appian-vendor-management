# Wedding Vendor Management System

**A comprehensive Appian-based vendor management interface for wedding planning with dynamic card layouts and Supabase integration.**

## 🎯 Project Overview

This system provides a modern, card-based interface for managing wedding vendors in Appian Community Edition. It features dynamic vendor cards with profile pictures, contact information, and seamless integration with Supabase for data persistence.

### ✨ Key Features

- **Dynamic Vendor Grid**: Responsive 4-column card layout that automatically adjusts based on vendor count
- **Visual Vendor Cards**: Each card displays business name, contact name, section type, and profile pictures
- **Supabase Integration**: Real-time data sync with PostgreSQL backend
- **Add Vendor Functionality**: Dedicated "+" card for adding new vendors
- **Scalable Design**: Handles 1-25 vendors with automatic row generation
- **Modern UI**: Clean, professional interface with rich text formatting and accent styling

## 🏗️ System Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Appian UI     │    │   Integration    │    │   Supabase DB   │
│                 │    │                  │    │                 │
│ • Vendor Cards  │◄──►│ • GET Vendors    │◄──►│ • vendorInfo    │
│ • Dynamic Grid  │    │ • POST New       │    │ • Profile Pics  │
│ • Add Button    │    │ • PUT Updates    │    │ • Contact Data  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 📋 Requirements

- **Appian Community Edition** (or higher)
- **Supabase Account** with PostgreSQL database
- **Connected System** configured for Supabase REST API
- **Image Storage** (Supabase Storage for profile pictures)

## 🚀 Quick Start

1. **Clone this repository**
   ```bash
   git clone https://github.com/your-username/appian-vendor-management.git
   ```

2. **Set up Supabase** (see [Database Setup Guide](docs/supabase-setup.md))

3. **Import Appian Objects**
   - Create Connected System for Supabase
   - Import integration objects
   - Deploy interface code

4. **Configure Integration**
   - Update `WB1_SUPABASE_GET` with your Supabase URL
   - Set up authentication tokens
   - Test vendor data retrieval

## 📁 Project Structure

```
appian-vendor-management/
├── README.md                          # This file
├── interfaces/
│   ├── vendor-grid-static.txt         # Working 4x3 static grid
│   ├── vendor-grid-dynamic.txt        # Dynamic grid (in development)
│   └── vendor-card-components.txt     # Reusable card components
├── integrations/
│   ├── supabase-get-vendors.txt       # GET integration
│   ├── supabase-post-vendor.txt       # POST integration  
│   ├── supabase-put-vendor.txt        # PUT integration
│   └── supabase-delete-vendor.txt     # DELETE integration
├── database/
│   ├── schema.sql                     # Supabase table definitions
│   ├── sample-data.sql                # Test vendor data
│   └── rls-policies.sql               # Row Level Security setup
├── docs/
│   ├── setup-guide.md                 # Complete setup instructions
│   ├── supabase-setup.md              # Database configuration
│   ├── appian-configuration.md        # Appian setup steps
│   └── troubleshooting.md             # Common issues and solutions
└── assets/
    ├── screenshots/                   # Interface screenshots
    └── architecture-diagram.png       # System architecture
```

## 🗄️ Database Schema

### vendorInformation Table

| Column | Type | Description |
|--------|------|-------------|
| `id` | integer | Primary key, auto-increment |
| `created_at` | timestamp | Record creation timestamp |
| `is_booked` | boolean | Vendor booking status |
| `vendor_type` | text | Category (Venue, Beauty, Food & Beverage, etc.) |
| `vendor_name` | text | Business/company name |
| `contact_name` | text | Primary contact person |
| `phone_number` | numeric | Contact phone number |
| `email` | text | Contact email address |
| `website` | text | Business website URL |
| `notes` | text | Additional notes and comments |
| `quoted_amount` | numeric | Price quote amount |
| `image_url` | text | Profile picture URL (Supabase Storage) |

## 🎨 Interface Features

### Vendor Card Display
- **Business Name**: Bold, prominent display
- **Contact Information**: Name, phone, email
- **Section Type**: Category classification  
- **Profile Pictures**: Thumbnail images with fallback
- **Click Actions**: Navigate to vendor details

### Dynamic Grid Layout
- **Responsive Design**: 4 cards per row
- **Auto-Scaling**: Adds rows as vendors increase
- **Add New Card**: Prominent "+" button for new vendors
- **Smart Spacing**: Consistent margins and alignment

## 🔧 Configuration

### Appian Objects Required
1. **Connected System**: Supabase REST API connection
2. **Integration Objects**: CRUD operations for vendor data
3. **Interface Objects**: Vendor grid and detail views
4. **Local Variables**: Data management and state handling

### Supabase Configuration
1. **Database Setup**: Create tables and relationships
2. **Storage Bucket**: Configure image upload storage
3. **API Keys**: Generate and secure access tokens
4. **RLS Policies**: Set up row-level security

## 📊 Current Status

### ✅ Completed Features
- Static 4x3 vendor grid with 12 fixed positions
- Supabase integration with GET operations
- Vendor card styling and layout
- Profile picture display
- Click handling for vendor selection

### 🚧 In Development
- Dynamic grid that scales with vendor count
- Add vendor functionality with "+" card
- Automatic row generation (1-25 vendors)
- Enhanced error handling

### 📋 Planned Features
- Vendor detail views
- Edit vendor functionality
- Delete vendor operations
- Search and filter capabilities
- Vendor type categorization
- Booking status management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Appian Community** for platform documentation and best practices
- **Supabase** for providing excellent PostgreSQL and storage services
- **Wedding Planning Community** for feature requirements and testing

## 📞 Support

For questions, issues, or contributions:
- Open an [Issue](https://github.com/jessa256/appian-vendor-management/issues)
- Check the [Documentation](docs/)
- Review [Troubleshooting Guide](docs/troubleshooting.md)

---

**Built with ❤️ for seamless wedding planning**
