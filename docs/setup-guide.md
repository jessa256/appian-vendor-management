# Complete Setup Guide
## Wedding Vendor Management System

This guide will walk you through setting up the complete Wedding Vendor Management System from scratch.

## 📋 Prerequisites

- **Appian Community Edition** account
- **Supabase** account (free tier available)
- **Basic knowledge** of Appian interface development
- **Git** for version control (optional)

## 🏗️ Part 1: Supabase Database Setup

### Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click **"New Project"**
3. Choose your organization
4. Fill in project details:
   - **Name**: `wedding-vendor-management`
   - **Database Password**: Create a strong password
   - **Region**: Choose closest to your location
5. Click **"Create new project"**
6. Wait for database to initialize (2-3 minutes)

### Step 2: Run Database Schema

1. Navigate to **SQL Editor** in Supabase dashboard
2. Create a new query
3. Copy and paste the contents of `database/schema.sql`
4. Execute the query to create tables and policies
5. Verify tables were created in **Table Editor**

### Step 3: Insert Sample Data

1. In SQL Editor, create another new query
2. Copy and paste the contents of `database/sample-data.sql`
3. Execute to populate with test vendor data
4. Verify data in **Table Editor** > **vendorInformation**

### Step 4: Configure Storage

1. Go to **Storage** in Supabase dashboard
2. Verify **vendor-profile-pics** bucket was created
3. Upload test images or use provided URLs
4. Test public access to uploaded images

### Step 5: Get API Credentials

1. Go to **Settings** > **API**
2. Copy these values for later:
   - **Project URL** (e.g., `https://xyz.supabase.co`)
   - **Project API Key** (anon/public key)
   - **Service Role Key** (for server operations)

## 🔧 Part 2: Appian Configuration

### Step 1: Create Connected System

1. In Appian Designer, go to **Build** > **Connected Systems**
2. Click **"Create Connected System"**
3. Choose **"HTTP"** connector
4. Configure with these settings:
   - **Name**: `Supabase_API`
   - **Base URL**: Your Supabase Project URL + `/rest/v1`
   - **Authentication**: API Key
   - **API Key Header**: `apikey`
   - **API Key Value**: Your Supabase anon key

### Step 2: Create GET Integration

1. Go to **Build** > **Integrations**
2. Click **"Create Integration"**
3. Choose your Supabase Connected System
4. Configure:
   - **Name**: `WB1_SUPABASE_GET`
   - **Description**: `Get vendor information from Supabase`
   - **Method**: GET
   - **Relative Path**: `/vendorInformation`
   - **Query Parameters**:
     - `select`: `*`
     - `order`: `created_at.asc`

#### Add Rule Inputs:
- **tableName** (Text): Default value `"vendorInformation"`
- **selectFields** (Text): Default value `"*"`
- **filters** (Text): Optional filters
- **orderBy** (Text): Default ordering

### Step 3: Create Additional Integrations

Create similar integrations for:

#### POST Integration (`WB1_SUPABASE_POST`)
- **Method**: POST
- **Relative Path**: `/vendorInformation`
- **Request Body**: JSON vendor object

#### PUT Integration (`WB1_SUPABASE_PUT`)
- **Method**: PUT
- **Relative Path**: `/vendorInformation`
- **Query Parameters**: `id=eq.{vendorId}`
- **Request Body**: JSON update object

#### DELETE Integration (`WB1_SUPABASE_DELETE`)
- **Method**: DELETE
- **Relative Path**: `/vendorInformation`
- **Query Parameters**: `id=eq.{vendorId}`

### Step 4: Test Integrations

1. Open each integration
2. Click **"Test Request"**
3. Verify successful responses
4. Check returned data structure
5. Save integration if tests pass

## 🎨 Part 3: Interface Deployment

### Step 1: Create Interface Object

1. Go to **Build** > **Interfaces**
2. Click **"Create Interface"**
3. Name: `WB1_Vendor_Management`
4. Choose **"Expression Mode"**

### Step 2: Deploy Working Interface

1. Copy the contents of `interfaces/vendor-grid-static.txt`
2. Paste into the interface expression editor
3. Update integration names if different
4. Save and test the interface

### Step 3: Verify Functionality

Test these features:
- [ ] Vendor cards display correctly
- [ ] Profile pictures load (where available)
- [ ] Business names appear in bold
- [ ] Contact information displays
- [ ] Cards are clickable
- [ ] All 12 vendor positions show data

## 🔍 Part 4: Testing & Validation

### Data Validation Tests

1. **Vendor Count**: Verify all vendors from database appear
2. **Image Loading**: Check profile pictures display correctly
3. **Data Accuracy**: Confirm vendor details match database
4. **Click Handling**: Test card selection functionality

### Performance Tests

1. **Load Time**: Interface should load within 2-3 seconds
2. **Image Performance**: Thumbnails should load quickly
3. **Responsiveness**: Test on different screen sizes

### Error Handling Tests

1. **Missing Data**: Test with vendors missing optional fields
2. **Broken Images**: Test with invalid image URLs
3. **Network Issues**: Test with slow/failed API responses

## 🚀 Part 5: Advanced Configuration

### Dynamic Grid Setup (Future)

1. Deploy dynamic interface from `interfaces/vendor-grid-dynamic.txt`
2. Test with varying vendor counts (1-25)
3. Verify "Add Vendor" card appears correctly
4. Test automatic row generation

### Security Configuration

1. **Row Level Security**: Enable appropriate RLS policies
2. **API Security**: Rotate API keys regularly
3. **Access Control**: Configure user permissions
4. **Data Validation**: Add input sanitization

### Performance Optimization

1. **Image Optimization**: Compress profile pictures
2. **Caching**: Enable appropriate caching policies
3. **Indexing**: Add database indexes for frequent queries
4. **CDN**: Consider CDN for image delivery

## 📊 Part 6: Monitoring & Maintenance

### Regular Maintenance Tasks

- [ ] **Weekly**: Check integration health
- [ ] **Monthly**: Review database performance
- [ ] **Quarterly**: Update dependencies
- [ ] **Annually**: Security audit

### Monitoring Setup

1. **Supabase Monitoring**: Enable database monitoring
2. **Appian Health Check**: Set up interface monitoring
3. **Error Logging**: Configure error notification
4. **Performance Metrics**: Track load times and usage

## 🆘 Troubleshooting

### Common Issues

1. **"Could not display interface"**
   - Check integration connectivity
   - Verify API credentials
   - Review Supabase logs

2. **Images not loading**
   - Check storage bucket permissions
   - Verify image URLs are accessible
   - Test storage policies

3. **Data not appearing**
   - Verify database connection
   - Check table permissions
   - Review integration response

See `docs/troubleshooting.md` for detailed solutions.

## ✅ Setup Completion Checklist

- [ ] Supabase project created and configured
- [ ] Database schema deployed successfully  
- [ ] Sample data inserted and verified
- [ ] Appian Connected System configured
- [ ] All integrations created and tested
- [ ] Interface deployed and functional
- [ ] Vendor cards displaying correctly
- [ ] Profile pictures loading properly
- [ ] Click functionality working
- [ ] Performance testing completed
- [ ] Security configurations applied
- [ ] Documentation reviewed

## 🎯 Next Steps

After completing this setup:

1. **Customize Vendor Types**: Add/modify vendor categories
2. **Enhance UI**: Customize colors, fonts, and layout
3. **Add Features**: Implement vendor details, editing, search
4. **Deploy Production**: Move from test to production environment
5. **User Training**: Train end users on the system

---

**Need help?** Check the [troubleshooting guide](troubleshooting.md) or open an issue in the repository.
