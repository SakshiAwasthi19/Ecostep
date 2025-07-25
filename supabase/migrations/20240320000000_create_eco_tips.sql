-- Create enum for tip categories
CREATE TYPE tip_category AS ENUM ('transport', 'energy', 'diet', 'waste');

-- Create eco_tips table
CREATE TABLE eco_tips (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    category tip_category NOT NULL,
    content TEXT NOT NULL,
    impact_level INTEGER NOT NULL CHECK (impact_level BETWEEN 1 AND 10),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add comment to explain the table
COMMENT ON TABLE eco_tips IS 'Stores eco-friendly tips and recommendations for users';

-- Add RLS policies
ALTER TABLE eco_tips ENABLE ROW LEVEL SECURITY;

-- Allow public read access to eco_tips
CREATE POLICY "Allow public read access to eco_tips" ON eco_tips
    FOR SELECT
    USING (true);

-- Insert some initial tips
INSERT INTO eco_tips (category, content, impact_level) VALUES
    -- Transport tips
    ('transport', 'Try carpooling with colleagues to work to reduce individual carbon emissions', 8),
    ('transport', 'Consider using public transportation for your daily commute', 7),
    ('transport', 'For short trips, opt for walking or cycling instead of driving', 6),
    ('transport', 'Maintain your vehicle properly to ensure optimal fuel efficiency', 5),
    ('transport', 'Plan and combine multiple errands into one trip to reduce unnecessary driving', 4),
    
    -- Energy tips
    ('energy', 'Switch to LED bulbs to reduce electricity consumption by up to 80%', 8),
    ('energy', 'Use a programmable thermostat to optimize heating and cooling', 7),
    ('energy', 'Seal air leaks around windows and doors to improve energy efficiency', 6),
    ('energy', 'Unplug electronics when not in use to avoid phantom energy consumption', 5),
    ('energy', 'Use natural light when possible and turn off lights in empty rooms', 4),
    
    -- Diet tips
    ('diet', 'Reduce meat consumption by incorporating more plant-based meals', 9),
    ('diet', 'Choose locally sourced and seasonal produce to reduce transportation emissions', 7),
    ('diet', 'Plan meals to minimize food waste and compost organic waste', 6),
    ('diet', 'Opt for products with minimal packaging to reduce waste', 5),
    ('diet', 'Grow your own herbs or vegetables to reduce grocery store trips', 4),
    
    -- Waste tips
    ('waste', 'Start composting food scraps to reduce landfill waste', 8),
    ('waste', 'Use reusable bags, water bottles, and coffee cups', 7),
    ('waste', 'Properly sort recyclables and learn local recycling guidelines', 6),
    ('waste', 'Repair items instead of replacing them when possible', 5),
    ('waste', 'Choose products with minimal or recyclable packaging', 4);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_eco_tips_updated_at
    BEFORE UPDATE ON eco_tips
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 