# Troubleshooting Guide
## Wedding Vendor Management System

This guide covers common issues and their solutions when setting up and running the Wedding Vendor Management System.

## 🚨 Interface Display Issues

### "Could not display interface. Please check definition and inputs."

**Symptoms:**
- Red error message in Appian interface
- Interface fails to load completely
- Error in expression evaluation

**Common Causes & Solutions:**

#### 1. Integration Connectivity Issues
```bash
# Check if integration exists and is properly named
Integration Name: WB1_SUPABASE_GET
Expected Format: cons!WB1_SUPABASE_GET
```

**Solution:**
- Verify integration object exists in your application
- Check integration name matches exactly in interface code
- Test integration independently in Integration Designer

#### 2. Local Variable Scoping Errors
```appian
# ❌ Incorrect - nested local variables
a!forEach(
  items: enumerate(4),
  expression: {
    local!cardPosition: fv!item, /* This causes scoping error */
    a!cardLayout(...)
  }
)

# ✅ Correct - inline calculations
a!forEach(
  items: enumerate(4),
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: index(local!vendorData.result.body, fv!item, {}).vendor_name
      )
    }
  )
)
```

**Solution:**
- Use inline calculations instead of nested local variables
- Define all local variables at the top level of `a!localVariables()`
- Use `fv!item` and `fv!index` directly in expressions

#### 3. Data Structure Mismatch
```appian
# ❌ Incorrect data access
local!vendorData.vendors  /* Wrong property name */

# ✅ Correct data access based on Supabase response
local!vendorData.result.body  /* Matches actual structure */
```

**Solution:**
- Check your integration response structure in Integration Designer
- Use correct property paths: `local!vendorData.result.body`
- Test data access with simple debug expressions

## 🔌 Integration Issues

### "Function 'cons!WB1_SUPABASE_GET' is unavailable"

**Symptoms:**
- Integration not found error
- Function unavailable messages
- Integration appears to not exist

**Solutions:**

1. **Check Integration Object Name:**
   ```appian
   # Verify exact name in Objects tab
   Object Type: Integration
   Name: WB1_SUPABASE_GET
   ```

2. **Verify Integration Dependencies:**
   - Connected System exists and is working
   - Integration is published/saved
   - No circular dependencies

3. **Test Integration Separately:**
   - Open integration in Integration Designer
   - Click "Test Request"
   - Verify successful response

### Integration Returns No Data

**Symptoms:**
- Interface loads but shows empty cards
- `length(local!vendorData.result.body)` returns 0
- No vendor information displayed

**Debugging Steps:**

1. **Check Integration Response:**
   ```appian
   # Add debug field to interface
   a!textDisplayField(
     label: "Debug - Response Structure",
     value: typeof(local!vendorData)
   )
   ```

2. **Verify Supabase Table:**
   - Check if `vendorInformation` table has data
   - Verify table name spelling matches exactly
   - Confirm Row Level Security policies allow access

3. **Test API Directly:**
   ```bash
   # Test Supabase REST API directly
   curl "https://your-project.supabase.co/rest/v1/vendorInformation" \
   -H "apikey: your-anon-key" \
   -H "Authorization: Bearer your-anon-key"
   ```

## 🖼️ Image Loading Issues

### Profile Pictures Not Displaying

**Symptoms:**
- Vendor cards show but no profile pictures
- Broken image icons
- Images load slowly or not at all

**Common Causes & Solutions:**

#### 1. Storage Bucket Permissions
```sql
-- Check storage policies in Supabase SQL Editor
SELECT * FROM storage.policies WHERE bucket_id = 'vendor-profile-pics';

-- Expected policy should allow public SELECT
CREATE POLICY "Allow public access to vendor profile pictures" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'vendor-profile-pics');
```

#### 2. Invalid Image URLs
```appian
# Debug image URLs
a!textDisplayField(
  label: "Debug - Image URL",
  value: index(local!vendorData.result.body, 1, {}).image_url
)
```

**Solution:**
- Verify URLs are properly formatted
- Test URLs directly in browser
- Check for null/empty image_url values

#### 3. Appian Image Component Issues
```appian
# ❌ Common mistake - missing showWhen
a!imageField(
  images: a!webImage(source: "invalid-url")
  /* Always shows broken image */
)

# ✅ Correct - conditional display
a!imageField(
  images: a!webImage(source: fv!item.image_url),
  showWhen: not(isnull(fv!item.image_url)),
  size: "MEDIUM",
  isThumbnail: true
)
```

## 🔄 Data Access Errors

### "Cannot index property 'vendor_name' of type String into type List"

**Symptoms:**
- Type mismatch errors
- Property access failures
- Unexpected data types

**Root Cause:**
- `index()` function returning wrong data type
- Data structure not matching expectations

**Solutions:**

1. **Check Integration Response Structure:**
   ```appian
   # Add debug information
   a!textDisplayField(
     label: "Vendor Data Type",
     value: typeof(local!vendorData.result.body)
   ),
   a!textDisplayField(
     label: "First Vendor Type",
     value: typeof(index(local!vendorData.result.body, 1, {}))
   )
   ```

2. **Verify Index Parameters:**
   ```appian
   # ❌ Incorrect index usage
   index(local!vendorData.result.body, fv!item, null)
   
   # ✅ Correct index usage
   index(local!vendorData.result.body, fv!item, {})
   ```

3. **Test with Safe Defaults:**
   ```appian
   # Safe property access with defaults
   property(
     index(local!vendorData.result.body, fv!item, {}),
     "vendor_name", 
     "Unknown Vendor"
   )
   ```

## 🎛️ Dynamic Grid Issues

### forEach Loops Not Working

**Symptoms:**
- Only first vendor displays
- Grid doesn't expand properly
- Cards appear in wrong positions

**Common Issues & Fixes:**

#### 1. Incorrect Row/Column Calculation
```appian
# ❌ Wrong calculation
local!cardPosition: fv!index * 4 + fv!item  /* Off by 4 */

# ✅ Correct calculation  
local!cardPosition: (fv!index - 1) * 4 + fv!item
```

#### 2. Missing showWhen Conditions
```appian
# ❌ Cards show even when no data
a!cardLayout(contents: {...})

# ✅ Conditional display
a!cardLayout(
  contents: {...},
  showWhen: fv!item <= length(local!vendorData.result.body)
)
```

## 🔐 Authentication & Security Issues

### "Row Level Security Policy Violation"

**Symptoms:**
- 403 Forbidden errors
- Data access denied
- Empty results despite data existing

**Solutions:**

1. **Check RLS Policies:**
   ```sql
   -- Verify policies exist
   SELECT * FROM pg_policies WHERE tablename = 'vendorInformation';
   
   -- Temporarily disable RLS for testing
   ALTER TABLE public.vendorInformation DISABLE ROW LEVEL SECURITY;
   ```

2. **Verify API Key Permissions:**
   - Use correct API key (anon vs service_role)
   - Check key hasn't expired
   - Verify key permissions in Supabase dashboard

3. **Test with Service Role Key:**
   ```bash
   # Test with elevated permissions
   curl "https://your-project.supabase.co/rest/v1/vendorInformation" \
   -H "apikey: your-service-role-key" \
   -H "Authorization: Bearer your-service-role-key"
   ```

## 🚀 Performance Issues

### Slow Interface Loading

**Symptoms:**
- Interface takes >5 seconds to load
- Cards appear slowly
- Timeout errors

**Optimization Steps:**

1. **Database Query Optimization:**
   ```sql
   -- Add indexes for better performance
   CREATE INDEX IF NOT EXISTS idx_vendor_name 
   ON public.vendorInformation(vendor_name);
   
   CREATE INDEX IF NOT EXISTS idx_vendor_type 
   ON public.vendorInformation(vendor_type);
   ```

2. **Image Optimization:**
   - Compress profile pictures (< 500KB each)
   - Use appropriate image formats (WebP, JPEG)
   - Consider lazy loading for large datasets

3. **Integration Optimization:**
   ```appian
   # Limit fields returned
   selectFields: "id,vendor_name,contact_name,vendor_type,image_url"
   
   # Add pagination for large datasets
   limitRecords: 25
   ```

## 🧪 Testing & Debugging

### Debug Information Template

Add this to your interface for debugging:

```appian
/* DEBUG SECTION - Remove in production */
a!sectionLayout(
  label: "Debug Information",
  contents: {
    a!textDisplayField(
      label: "Vendor Count",
      value: length(local!vendorData.result.body)
    ),
    a!textDisplayField(
      label: "Data Structure",
      value: typeof(local!vendorData)
    ),
    a!textDisplayField(
      label: "First Vendor",
      value: index(local!vendorData.result.body, 1, "No data")
    ),
    a!textDisplayField(
      label: "Integration Response",
      value: local!vendorData
    )
  },
  isCollapsible: true,
  isInitiallyCollapsed: true
)
```

### Step-by-Step Debugging Process

1. **Start Simple:**
   - Test with minimal interface
   - Add complexity gradually
   - Isolate problematic components

2. **Check Each Layer:**
   - Database → Integration → Interface
   - Test each independently
   - Verify data flow at each step

3. **Use Browser Developer Tools:**
   - Check network requests
   - Look for JavaScript errors
   - Monitor API response times

## 📞 Getting Help

### Before Asking for Help

Provide this information:

1. **Error Message:** Exact text of any error messages
2. **Steps to Reproduce:** What actions trigger the issue
3. **Environment:** Appian version, browser, etc.
4. **Integration Response:** Sample API response from Supabase
5. **Code Sample:** Relevant interface code snippet

### Resources

- **Appian Community:** [community.appian.com](https://community.appian.com)
- **Supabase Docs:** [supabase.com/docs](https://supabase.com/docs)
- **GitHub Issues:** Open an issue in this repository
- **Debug Logs:** Check Appian application logs

### Emergency Rollback

If issues persist, rollback to working version:

1. Use the static grid from `interfaces/vendor-grid-static.txt`
2. Verify basic functionality works
3. Debug dynamic features separately
4. Deploy fixes incrementally

---

**Remember:** Most issues are caused by data structure mismatches or integration connectivity. Start with the basics and work your way up!
