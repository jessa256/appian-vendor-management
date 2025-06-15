-- Wedding Vendor Management System
-- Supabase Database Schema

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret-here';

-- Create vendorInformation table
CREATE TABLE public.vendorInformation (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    is_booked BOOLEAN DEFAULT false NOT NULL,
    vendor_type TEXT NOT NULL,
    vendor_name TEXT NOT NULL,
    contact_name TEXT,
    phone_number NUMERIC,
    email TEXT,
    website TEXT,
    notes TEXT,
    quoted_amount NUMERIC(10,2),
    image_url TEXT
);

-- Create indexes for better performance
CREATE INDEX idx_vendor_type ON public.vendorInformation(vendor_type);
CREATE INDEX idx_vendor_name ON public.vendorInformation(vendor_name);
CREATE INDEX idx_is_booked ON public.vendorInformation(is_booked);
CREATE INDEX idx_created_at ON public.vendorInformation(created_at);

-- Create vendorTypes lookup table
CREATE TABLE public.vendorTypes (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    vendor_type TEXT UNIQUE NOT NULL
);

-- Insert default vendor types
INSERT INTO public.vendorTypes (vendor_type) VALUES
    ('Venue'),
    ('Beauty'),
    ('Food & Beverage'),
    ('Stationery & Signage'),
    ('Photographer'),
    ('Wedding Planner & Coordinator'),
    ('Jewelry'),
    ('Decor'),
    ('Music & Entertainment'),
    ('Transportation'),
    ('Florist'),
    ('Officiant');

-- Create storage bucket for vendor profile pictures
INSERT INTO storage.buckets (id, name, public) VALUES ('vendor-profile-pics', 'vendor-profile-pics', true);

-- Enable Row Level Security on tables
ALTER TABLE public.vendorInformation ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendorTypes ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Allow all operations for authenticated users (adjust as needed)
CREATE POLICY "Enable all operations for authenticated users" ON public.vendorInformation
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Enable read access for all users" ON public.vendorTypes
    FOR SELECT USING (true);

-- Create storage policies for profile pictures
CREATE POLICY "Allow public access to vendor profile pictures" ON storage.objects
    FOR SELECT USING (bucket_id = 'vendor-profile-pics');

CREATE POLICY "Allow authenticated users to upload vendor profile pictures" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'vendor-profile-pics' AND auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update vendor profile pictures" ON storage.objects
    FOR UPDATE WITH CHECK (bucket_id = 'vendor-profile-pics' AND auth.role() = 'authenticated');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_vendorInformation_updated_at 
    BEFORE UPDATE ON public.vendorInformation 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create view for vendor summary statistics
CREATE VIEW public.vendor_stats AS
SELECT 
    vendor_type,
    COUNT(*) as total_vendors,
    COUNT(CASE WHEN is_booked = true THEN 1 END) as booked_vendors,
    COUNT(CASE WHEN is_booked = false THEN 1 END) as available_vendors,
    AVG(quoted_amount) as avg_quote,
    SUM(quoted_amount) as total_quotes
FROM public.vendorInformation 
GROUP BY vendor_type;

-- Grant permissions
GRANT ALL ON public.vendorInformation TO authenticated;
GRANT ALL ON public.vendorTypes TO authenticated;
GRANT SELECT ON public.vendor_stats TO authenticated;
GRANT USAGE ON SEQUENCE public.vendorInformation_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE public.vendorTypes_id_seq TO authenticated;
