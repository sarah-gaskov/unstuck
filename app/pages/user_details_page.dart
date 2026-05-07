import 'package:flutter/material.dart';
import '../api_service.dart';
import 'login_page.dart';

class UserDetailsPage extends StatefulWidget {
  final String username;
  final String password;
  const UserDetailsPage({super.key, required this.username, required this.password});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final ApiService api = ApiService();
  bool _isSigningUp = false;

  String? _selectedMake;
  String? _selectedModel;
  String? _selectedYear;

  final Map<String, List<String>> _carModels = {
  'Chevrolet': [
    // Classics & Muscle
    'Bel Air', 'Impala', 'Impala SS', 'Impala Z11', 'Caprice', 'Biscayne', 'Brookwood',
    'Kingswood', 'Yeoman', 'Townsman', 'Nomad', 'El Morocco',
    'Chevelle', 'Chevelle SS 396', 'Chevelle SS 454 LS6', 'Chevelle Z16', 'Chevelle Laguna',
    'Chevelle Yenko SC', 'Malibu',
    'Camaro', 'Camaro Z/28', 'Camaro ZL1', 'Camaro COPO ZL1', 'Camaro SS', 'Camaro RS',
    'Camaro 1LE', 'Camaro Berlinetta',
    'Corvette', 'Corvette C1', 'Corvette C2', 'Corvette C3', 'Corvette C4', 'Corvette C5',
    'Corvette C6', 'Corvette C7', 'Corvette C8', 'Corvette Grand Sport', 'Corvette ZR1',
    'Corvette Z06', 'Corvette L88', 'Corvette ZL1 (1969)', 'Corvette E-Ray',
    'Corvette Baldwin Motion Phase III GT',
    'Nova', 'Nova SS', 'Nova COPO', 'Nova Yenko SC 427',
    'Monte Carlo', 'Monte Carlo SS', 'El Camino', 'El Camino SS LS6',
    // Early/Classic Models
    'Series C Classic Six', 'Series 490', 'Superior K', 'Model D', 'Master',
    'Fleetline', 'Stylemaster', 'Fleetmaster',
    // Compact & Economy
    'Corvair', 'Corvair Greenbrier', 'Corvair Monza', 'Vega', 'Monza', 'Monza Mirage',
    'Citation', 'Cavalier', 'Cobalt', 'Cruze', 'Sonic', 'Spark',
    'Chevette', 'Spectrum', 'Sprint', 'Nova (1985)', 'Geo Metro', 'Geo Storm',
    // Sedans & Family
    'Celebrity', 'Corsica', 'Beretta', 'Lumina', 'Malibu', 'Impala',
    'Caprice Classic', 'Caprice PPV',
    // SUVs & Trucks
    'Suburban', 'Tahoe', 'Blazer', 'Blazer K5', 'TrailBlazer', 'TrailBlazer EXT',
    'Equinox', 'Equinox EV', 'Trax', 'Trailblazer',
    'Silverado 1500', 'Silverado 2500HD', 'Silverado 3500HD', 'Silverado EV',
    'Colorado', 'S-10', 'C/K Truck', 'LUV', 'Avalanche', 'SSR', 'Kodiak',
    'Colorado ZR2', 'Silverado ZR2',
    // Vans & MPV
    'Astro', 'Express', 'Venture', 'Uplander',
    // EVs & Modern
    'Volt', 'Bolt EV', 'Bolt EUV', 'Tracker',
    // Performance Packages
    'Camaro IROC-Z', 'Camaro Pace Car', 'Impala SS (1994)', 'SS Truck (1990)',
  ],

  'Dodge': [
    // Muscle & Performance
    'Charger', 'Charger R/T', 'Charger Daytona', 'Charger Super Bee', 'Charger SRT Hellcat',
    'Charger SRT Hellcat Redeye', 'Charger SRT Hellcat Jailbreak',
    'Challenger', 'Challenger R/T', 'Challenger T/A', 'Challenger SRT8',
    'Challenger SRT Hellcat', 'Challenger SRT Demon', 'Challenger SRT Super Stock',
    'Challenger SRT Demon 170',
    'Viper', 'Viper GTS', 'Viper GTS-R', 'Viper ACR', 'Viper SRT10',
    'Super Bee', 'Coronet', 'Coronet R/T', 'Polara', 'Monaco',
    'Dart', 'Dart GTS', 'Dart Swinger', 'Dart GT',
    'Demon (classic)', 'Deora (show truck)',
    // Classic Trucks
    'D100', 'D200', 'D300', 'Power Wagon', 'Lil Red Express Truck', 'Rampage',
    // Modern Trucks & SUVs
    'Ram (classic)', 'Durango', 'Durango SRT', 'Durango Hellcat',
    'Dakota', 'Nitro', 'Journey',
    // Compact & Economy
    'Neon', 'Neon SRT-4', 'Caliber', 'Caliber SRT4', 'Avenger',
    'Shadow', 'Spirit', 'Spirit R/T', 'Stratus', 'Intrepid', 'Dynasty',
    'Omni', 'Omni GLH', 'Omni GLH-S', 'Aries', 'Lancer',
    // Sports & Specialty
    'Stealth', 'Stealth R/T Turbo', 'Colt', 'Conquest', 'Daytona',
    'Daytona Shelby Z', 'Daytona Turbo', 'Shelby Charger', 'Shelby GLHS',
    // Vans
    'Grand Caravan', 'Caravan', 'B-Series Van',
    // EV
    'Hornet', 'Charger Daytona EV',
  ],

  'BMW': [
    // Current Lineup
    '1 Series', '2 Series', '3 Series', '4 Series', '5 Series', '6 Series',
    '7 Series', '8 Series',
    'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'XM',
    'Z3', 'Z4', 'Z8',
    // M Performance
    'M2', 'M3', 'M4', 'M5', 'M6', 'M8',
    'M135i', 'M235i', 'M240i', 'M340i', 'M440i', 'M550i', 'M760i',
    'X3 M', 'X4 M', 'X5 M', 'X6 M',
    'M3 CS', 'M3 CSL', 'M4 CSL', 'M4 GTS', 'M5 CS',
    // Electric
    'i3', 'i4', 'i5', 'i7', 'i8', 'iX', 'iX1', 'iX3',
    // Niche / Enthusiast
    'E30 M3', 'E36 M3', 'E46 M3', 'E90 M3', 'E92 M3',
    'E28 M5', 'E34 M5', 'E39 M5', 'E60 M5',
    '2002', '2002 Tii', '2002 Turbo', '1600', '1800',
    '3.0 CSL', '3.0 CSi', 'E9 Coupe',
    '850i', '850CSi', '840Ci',
    'Z1', 'Z3 M Coupe', 'Z3 M Roadster',
    '1M Coupe', 'M1',
    '507', '328 (pre-war)', '327',
    'Isetta', 'New Class 1500',
    'M3 GTR', 'M3 GTS', 'M6 GT3',
  ],

  'Mercedes-Benz': [
    // Current Lineup
    'A-Class', 'B-Class', 'C-Class', 'CLA-Class', 'CLS-Class',
    'E-Class', 'S-Class', 'G-Class', 'GLA-Class', 'GLB-Class',
    'GLC-Class', 'GLE-Class', 'GLS-Class', 'V-Class', 'Metris', 'Sprinter',
    // Discontinued
    'GL-Class', 'GLK-Class', 'ML-Class', 'R-Class',
    'CL-Class', 'CLK-Class', 'SLK-Class', 'SLC-Class',
    'SL-Class', 'SLS AMG', 'SLR McLaren', 'SLR Stirling Moss',
    // AMG Performance
    'AMG GT', 'AMG GT R', 'AMG GT Black Series', 'AMG GT S', 'AMG GT 63',
    'C 63 AMG', 'C 63 AMG Black Series',
    'E 63 AMG', 'S 63 AMG', 'S 65 AMG',
    'G 63 AMG', 'G 65 AMG', 'G 55 AMG',
    'CL 65 AMG', 'CLK GTR', 'CLK 63 AMG Black Series',
    'SL 65 AMG Black Series',
    // Maybach
    'Maybach S-Class', 'Maybach GLS', 'Maybach 57', 'Maybach 62',
    // Electric (EQ)
    'EQA', 'EQB', 'EQC', 'EQE', 'EQS', 'EQV', 'EQE SUV', 'EQS SUV',
    // Niche / Classic
    '300SL Gullwing', '300SL Roadster', '300SLR', '190SL',
    '190E 2.3-16', '190E 2.5-16 Evolution II',
    '450SEL 6.9', '600 Pullman', '300 Adenauer',
    'W125', 'W196', 'W154',
    'Unimog', 'CLK GTR Street Version',
    '500E', '400E', 'W201', 'W124',
    '560SEL', '560SEC', '380SL', '450SL', '500SL',
  ],

  'Hyundai': [
    'Accent', 'Elantra', 'Elantra N', 'Elantra N Line', 'Sonata', 'Sonata N Line',
    'Azera', 'Tucson', 'Tucson N Line', 'Santa Fe', 'Palisade',
    'Kona', 'Kona N', 'Kona Electric', 'Venue', 'Nexo',
    'Ioniq', 'Ioniq 5', 'Ioniq 5 N', 'Ioniq 6', 'Ioniq 9',
    'Santa Cruz', 'Staria',
    'Genesis (sedan)', 'Equus', 'Veracruz',
    'Tiburon', 'Tuscani', 'Coupe',
    'Veloster', 'Veloster N', 'Veloster Turbo',
    'i10', 'i20', 'i20 N', 'i30', 'i30 N', 'i40',
    'Atos', 'Getz', 'Matrix', 'XG300', 'XG350',
    'Trajet', 'Terracan', 'Entourage', 'Creta', 'Bayon', 'Casper',
    'N Vision 74 (concept)', 'Prophecy (concept)',
    'Pony (1975)', 'Stellar', 'Excel', 'Scoupe',
    'Grandeur', 'Dynasty', 'Equus VI',
  ],

  'Kia': [
    'Rio', 'Forte', 'Forte GT', 'K5', 'K5 GT', 'Stinger', 'Stinger GT', 'Stinger GT2',
    'Cadenza', 'K900', 'Soul', 'Soul EV', 'Soul GT-Line',
    'Seltos', 'Sportage', 'Sportage X-Pro', 'Sorento', 'Sorento PHEV',
    'Telluride', 'Carnival', 'EV6', 'EV6 GT', 'EV9', 'EV3', 'EV5',
    'Niro', 'Niro EV', 'Niro PHEV',
    'Sedona', 'Borrego', 'Amanti', 'Optima', 'Optima SX',
    'Spectra', 'Spectra5', 'Sephia', 'Rondo', 'Magentis',
    'Ceed', 'ProCeed', 'XCeed', 'Picanto', 'Stonic', 'Proceed GT',
    'K8', 'K9 (Quoris)', 'Mohave', 'Retona',
    'Pride', 'Besta', 'Concord', 'Credos', 'Carens', 'Opirus',
  ],

  'Subaru': [
    'Impreza', 'Legacy', 'Outback', 'Forester', 'Crosstrek', 'Crosstrek Wilderness',
    'Ascent', 'Solterra', 'BRZ', 'BRZ tS', 'WRX', 'WRX TR',
    'WRX STI', 'WRX STI S209', 'WRX STI S207', 'WRX STI S206',
    'WRX STI Type RA', 'WRX STI EJ20 Final Edition',
    'Impreza 22B STi', 'Impreza P1', 'Impreza WRX STi Type R',
    'BRZ STI Sport', 'BRZ RA Racing',
    'Forester STI', 'Legacy STI', 'Outback XT',
    'Impreza WRC', 'Legacy RS', 'Legacy GT',
    'Baja', 'Tribeca', 'XV', 'Exiga',
    'SVX', 'SVX LSi', 'XT', 'XT6',
    'Leone', 'GL', 'DL', 'Loyale',
    'Vivio', 'Vivio RX-R', 'Rex', 'Justy', 'Sambar',
    'Domingo', 'Libero', 'R2', 'R1', 'Stella', 'Pleo', 'Lucra', 'Trezia',
  ],

  'Jeep': [
    'Wrangler', 'Wrangler Rubicon', 'Wrangler Sahara', 'Wrangler 392',
    'Wrangler 4xe', 'Wrangler Willys',
    'Cherokee', 'Grand Cherokee', 'Grand Cherokee L', 'Grand Cherokee 4xe',
    'Grand Cherokee Trackhawk', 'Grand Cherokee SRT',
    'Compass', 'Renegade', 'Gladiator', 'Gladiator Rubicon', 'Gladiator Mojave',
    'Wagoneer', 'Grand Wagoneer', 'Avenger',
    'Commander', 'Liberty', 'Patriot',
    'CJ-2A', 'CJ-3A', 'CJ-3B', 'CJ-5', 'CJ-6', 'CJ-7', 'CJ-8 Scrambler',
    'Willys MB', 'Willys CJ-2', 'Willys Jeepster',
    'FC-150', 'FC-170', 'Jeepster Commando',
    'Grand Wagoneer (classic)', 'Wagoneer (classic)',
    'Cherokee XJ', 'Cherokee SJ',
    'Grand Cherokee ZJ', 'Grand Cherokee WJ',
    'Jeep Hurricane (concept)', 'Recon (upcoming EV)', 'Dakar', 'Moab Edition',
  ],

  'GMC': [
    'Sierra 1500', 'Sierra 2500HD', 'Sierra 3500HD',
    'Sierra 1500 AT4', 'Sierra 1500 AT4X', 'Sierra 1500 Denali',
    'Sierra EV', 'Canyon', 'Canyon AT4X', 'Canyon Denali',
    'Terrain', 'Terrain Denali', 'Acadia', 'Acadia Denali',
    'Yukon', 'Yukon XL', 'Yukon Denali', 'Yukon XL Denali',
    'Hummer EV', 'Hummer EV SUV', 'Envista',
    'Envoy', 'Envoy XL', 'Envoy XUV',
    'Jimmy', 'Safari', 'Vandura', 'Rally', 'Suburban',
    'Sonoma', 'Sonoma GT', 'Syclone', 'Typhoon',
    'C/K Truck', 'C10', 'C15', 'C20', 'C30',
    'W300 Forward Control', 'Crackerbox (cabover)', 'Motorhome', 'Palm Beach',
  ],

  'Volkswagen': [
    'Golf', 'Golf GTI', 'Golf R', 'Golf GTE', 'Golf Alltrack',
    'Jetta', 'Jetta GLI', 'Passat', 'Arteon', 'Arteon Shooting Brake',
    'Tiguan', 'Taos', 'Atlas', 'Atlas Cross Sport',
    'ID.3', 'ID.4', 'ID.5', 'ID.6', 'ID.7', 'ID. Buzz',
    'Polo', 'Polo GTI', 'Up!', 'Up! GTI',
    'Beetle', 'New Beetle', 'Beetle RSi',
    'Corrado', 'Corrado G60', 'Corrado VR6',
    'Scirocco', 'Scirocco R', 'Eos', 'CC', 'Phaeton',
    'Routan', 'Touran', 'Sharan', 'Fox', 'Vento', 'Bora', 'Bora V6 4Motion',
    'Transporter T1-T7', 'Caravelle', 'Crafter', 'Amarok', 'Amarok V6', 'Caddy',
    'Golf I GTI', 'Golf II GTI', 'Golf III VR6',
    'Golf IV R32', 'Golf V R32',
    'Golf II Country', 'Golf Syncro',
    'Rallye Golf', 'Golf Harlekin', 'Golf Harlequin',
    'XL1', 'L1 (concept)', 'W12 Nardò (concept)',
    '1200 Beetle', '1303 Beetle', 'Karmann Ghia',
    'Type 3', 'Type 4', 'Type 34 Karmann Ghia',
    'VW 411', 'VW 412', 'Kubelwagen', 'Schwimmwagen',
    'Santana', 'Passat W8', 'Lupo GTI', 'Lupo 3L',
    'Polo G40', 'Polo R WRC',
  ],

  'Mazda': [
    'Mazda2', 'Mazda3', 'Mazda3 Turbo', 'Mazda6',
    'CX-3', 'CX-30', 'CX-30 Turbo', 'CX-5', 'CX-50', 'CX-60',
    'CX-70', 'CX-80', 'CX-90', 'MX-5 Miata', 'MX-5 RF', 'MX-30',
    'MX-5 Miata NB', 'MX-5 Miata NA', 'MX-5 Miata NC', 'MX-5 Miata ND',
    'MX-5 Cup', 'MX-5 Club', 'MX-5 Grand Touring',
    'Mazdaspeed3', 'Mazdaspeed6', 'Mazdaspeed Protege', 'Mazdaspeed MX-5',
    'RX-7', 'RX-7 SA', 'RX-7 FB', 'RX-7 FC', 'RX-7 FD',
    'RX-7 Spirit R', 'RX-7 Bathurst R',
    'RX-8', 'RX-8 Spirit R', 'RX-8 Type S',
    'Cosmo Sport', 'Cosmo 110S', 'Cosmo AP',
    'RX-3', 'RX-4', 'RX-2',
    'Familia', 'Familia Rotary', 'Capella', 'Luce',
    '323', '323 GTX', '323 GT', '626', 'Millenia', 'Xedos 6', 'Xedos 9',
    'B-Series', 'MPV', 'Navajo', 'Tribute', 'Bongo', 'CX-7',
    'Carol', 'AZ-1', 'Autozam AZ-1', 'Autozam Scrum',
    'Eunos Roadster', 'Eunos Cosmo', 'Eunos 800', 'Eunos 500',
    'Lantis', 'Demio', 'Axela', 'Atenza', 'Premacy',
    '767B', '787B', '767',
  ],

  'Audi': [
    'A1', 'A3', 'A3 Sportback', 'A4', 'A4 Allroad', 'A5', 'A6', 'A6 Allroad',
    'A7', 'A8', 'A8 L',
    'Q2', 'Q3', 'Q4 e-tron', 'Q5', 'Q5 Sportback', 'Q6 e-tron',
    'Q7', 'Q8', 'Q8 e-tron', 'Q8 Sportback e-tron',
    'TT', 'TTS', 'TT RS',
    'R8', 'R8 V10', 'R8 V10 Plus', 'R8 GT', 'R8 LMS',
    'S3', 'S4', 'S5', 'S6', 'S7', 'S8',
    'RS3', 'RS4', 'RS4 Avant', 'RS5', 'RS6', 'RS6 Avant',
    'RS7', 'RS Q3', 'RS Q8',
    'e-tron GT', 'RS e-tron GT',
    'Sport Quattro', 'Sport Quattro S1',
    'Ur-quattro', 'RS2 Avant', 'S1', 'S1 Quattro (Group B)',
    'V8 Quattro', '80', '90', '100', '200', '200 Turbo Quattro',
    'Coupe GT', 'Coupe Quattro', '4000', '5000', '5000CS Turbo',
    'Fox', 'Cabriolet', 'Allroad (C5)', 'A2',
    'R18 e-tron quattro', 'R15 TDI', 'R10 TDI',
    'Auto Union Type C', 'Auto Union Streamliner',
  ],

  'Lexus': [
    'IS', 'IS 300', 'IS 350', 'IS 500', 'ES', 'ES 350', 'ES 300h',
    'GS', 'LS', 'LS 500', 'LS 500h',
    'LC', 'LC 500', 'LC 500h', 'LC Convertible',
    'RC', 'RC 350', 'RC F', 'RC F Track Edition',
    'UX', 'NX', 'NX 450h+', 'RX', 'RX 500h', 'GX', 'LX', 'TX', 'RZ',
    'IS F', 'GS F', 'LFA', 'LFA Nürburgring Package',
    'LC 500 Inspiration Series', 'LC 500h Black Inspiration',
    'CT 200h', 'HS 250h',
    'SC 300', 'SC 400', 'SC 430',
    'IS 300 SportCross', 'GS 300 (JDM)', 'GS 400',
    'LS 400 (UCF10)', 'LS 430', 'LS 460',
    'GX 470', 'LX 450', 'LX 470',
    'RX 300 (first gen)', 'ES 250',
    'Celsior (JDM LS)', 'Soarer (JDM SC)', 'Aristo (JDM GS)',
  ],

  'Ram': [
    '1500', '1500 Classic', '1500 TRX', '1500 RHO',
    '2500', '3500', '4500', '5500',
    'ProMaster', 'ProMaster City', 'ProMaster Van',
    'Dakota', 'Ram 50', '1500 REV (EV)',
    'Ram SRT-10', '1500 Rebel', '1500 Laramie Longhorn',
    'Power Wagon', 'Warlock', 'Ram Runner', '1500 Mopar',
    'D-Series', 'W100', 'W150', 'W200', 'W300',
    'Lil Red Express Truck', 'Macho Power Wagon',
    'Ram Van', 'Ram Wagon', 'C/V Tradesman',
  ],

  'Buick': [
    'Enclave', 'Encore', 'Encore GX', 'Envision', 'Envista',
    'LaCrosse', 'Regal', 'Regal GS', 'Regal Sportback', 'Regal TourX',
    'Verano', 'Cascada', 'Lucerne',
    'Terraza', 'Rendezvous', 'Rainier',
    'Century', 'LeSabre', 'Park Avenue', 'Park Avenue Ultra',
    'Riviera', 'Skylark', 'Skyhawk', 'Somerset',
    'Electra', 'Wildcat', 'Special', 'Special Skylark',
    'GS 400', 'GS 455', 'GSX Stage 1',
    'Roadmaster', 'Reatta',
    'Y-Job (1938 concept)', 'Le Sabre (1951 concept)',
    'XP-300', 'Centurion', 'Gran Sport', 'Gran Sport Stage 1',
    'Skylark Sport Wagon', 'Limited', 'Super', 'Apollo', 'Estate Wagon',
  ],

  'Cadillac': [
    'CT4', 'CT4-V', 'CT4-V Blackwing',
    'CT5', 'CT5-V', 'CT5-V Blackwing',
    'Escalade', 'Escalade ESV', 'Escalade V',
    'XT4', 'XT5', 'XT6',
    'Lyriq', 'Celestiq', 'Optiq', 'Vistiq',
    'CTS', 'CTS-V', 'CTS-V Wagon', 'CTS-V Coupe',
    'ATS', 'ATS-V', 'XTS', 'SRX', 'STS', 'DTS',
    'DeVille', 'DeVille DTS', "DeVille d'Elegance",
    'Eldorado', 'Eldorado Biarritz', 'Eldorado Brougham',
    'Seville', 'Seville STS', 'Fleetwood', 'Fleetwood Brougham',
    'Catera', 'Allante', 'Cimarron', 'BLS', 'SLS',
    'XLR', 'XLR-V',
    'Series 62', 'Series 60 Special',
    'Series 75 Limousine', 'Series 70 Fleetwood',
    'V-16 (1930s)', 'V-12',
    'La Espada (concept)', 'Cyclone (concept)', 'Cien (concept)', 'Sixteen (concept)',
    'Model A (1902)', 'Model B (1903)',
    'Coupe de Ville', 'Sedan de Ville',
    'Commercial Chassis (hearse/ambulance base)',
  ],

  'Saab': [
    '92', '93', '94', '95', '96', '99', '900', '9000',
    '9-3', '9-3 Viggen', '9-3 Aero', '9-3 SportCombi',
    '9-5', '9-5 Aero', '9-5 SportCombi', '9-5 Sedan (2010)',
    '9-7X', '9-2X', '9-2X Aero', '9-4X',
    'Sonett', 'Sonett II', 'Sonett III',
    'Lansen', 'Draken', 'Viggen (jet)',
    '9-X (concept)', '9-X Air (concept)',
    'EV-1 (concept)', 'Aero-X (concept)',
    'Monte Carlo 850 (1966 race car)',
  ],

  'MINI': [
    'Cooper 3-door', 'Cooper 5-door', 'Cooper S', 'Cooper SE',
    'Cooper Convertible', 'Cooper S Convertible',
    'John Cooper Works', 'John Cooper Works GP',
    'Countryman', 'Countryman S', 'Countryman JCW', 'Countryman SE ALL4',
    'Clubman', 'Clubman S', 'Clubman JCW', 'Aceman',
    'Paceman', 'Roadster', 'Coupe',
    'Original Mini (1959)', 'Mini Cooper S (1965)',
    'Mini Moke', 'Mini Clubman (classic)', 'Mini 1275 GT',
    'John Cooper Works GP (F56)', 'GP1', 'GP2', 'GP3',
    'Mini Challenge', 'Mini WRC',
    'Mini Seven', 'Mini Mayfair',
    'Traveller (classic)', 'Pickup (classic)', 'Mini E (2009)',
  ],

  'Fiat': [
    '500', '500e', '500X', '500L', '500 Abarth', '500 Abarth Competizione',
    'Panda', 'Tipo', '600', 'Topolino', 'Topolino EV',
    'Punto', 'Punto Abarth', 'Bravo', 'Brava', 'Stilo', 'Croma',
    'Doblo', 'Freemont', 'Linea', 'Palio', 'Siena',
    '124 Spider', '124 Sport Spider',
    'Seicento', 'Cinquecento (classic)', 'Multipla', 'Qubo', 'Scudo', 'Ducato',
    '8V', 'Dino', 'Dino Coupe', 'Dino Spider',
    '131 Abarth', '131 Rally', 'Ritmo Abarth 130TC',
    'X1/9', '128', '127', '126',
    '850 Spider', '850 Coupe', '600 Multipla (classic)',
    '2300 S Coupe', 'Barchetta',
    'Panda 4x4', 'Panda 100HP',
    '500 Abarth esseesse', 'Abarth 695 Biposto',
    'Campagnola', '238', 'Ulysse', 'Nuova 500 (1957)',
  ],

  'Tesla': [
    'Model S', 'Model S Plaid', 'Model S Plaid+',
    'Model 3', 'Model 3 Performance', 'Model 3 Highland',
    'Model X', 'Model X Plaid',
    'Model Y', 'Model Y Performance',
    'Cybertruck', 'Cybertruck Foundation Series',
    'Roadster (2008)', 'Roadster Sport (2008)', 'Roadster (2nd gen)',
    'Semi', 'Model 2',
    'Model S P100D', 'Model S P90D', 'Model S P85D',
    'Model 3 Dual Motor Long Range',
  ],

  'Porsche': [
    '911', '911 Carrera', '911 Carrera S', '911 Carrera 4', '911 Carrera 4S',
    '911 Targa', '911 Targa 4S', '911 Turbo', '911 Turbo S',
    '911 GT3', '911 GT3 RS', '911 GT3 Touring', '911 GT2 RS',
    '911 R', '911 Speedster', '911 Sport Classic', '911 Dakar',
    '718 Boxster', '718 Boxster S', '718 Boxster GTS', '718 Boxster Spyder',
    '718 Cayman', '718 Cayman S', '718 Cayman GT4', '718 Cayman GT4 RS',
    'Panamera', 'Panamera Turbo S', 'Panamera Sport Turismo',
    'Macan', 'Macan S', 'Macan GTS', 'Macan Turbo', 'Macan EV',
    'Cayenne', 'Cayenne S', 'Cayenne GTS', 'Cayenne Turbo S',
    'Cayenne E-Hybrid', 'Cayenne Coupe',
    'Taycan', 'Taycan Turbo', 'Taycan Turbo S', 'Taycan Turbo GT',
    'Taycan Sport Turismo', 'Taycan Cross Turismo',
    '356', '356 Speedster', '356 Carrera', '550 Spyder',
    '904 Carrera GTS', '906', '907', '908', '910',
    '914', '914-6', '924', '924 Carrera GT', '924 Turbo',
    '944', '944 Turbo', '944 S2', '944 Turbo S',
    '968', '968 CS', '928', '928 GTS', '959', '959 S',
    'Carrera GT', '918 Spyder', '918 Spyder Weissach',
    '911 GT1', '911 GT1 Strassenversion',
    '911 RSR', '911 R (2016)',
    '935', '936', '956', '962', '917',
    '911 Safari', '911 Targa Rally',
    '911 Club Sport', '911 Lightweight',
    'Spyder RS 60', '550 A Spyder',
  ],

  'Jaguar': [
    'XE', 'XF', 'XF Sportbrake', 'XJ', 'F-Type', 'F-Type R',
    'E-Pace', 'F-Pace', 'F-Pace SVR', 'I-Pace',
    'XK', 'XKR', 'XKR-S', 'XK120', 'XK140', 'XK150',
    'S-Type', 'S-Type R', 'X-Type', 'XJ6', 'XJ8', 'XJ12', 'XJR', 'XJS', 'XJL',
    'E-Type', 'E-Type Series 1', 'E-Type Series 2', 'E-Type Series 3',
    'E-Type Lightweight', 'E-Type Zero (EV)',
    'C-Type', 'D-Type',
    'Mark 1', 'Mark 2', 'Mark 2 3.8', 'Mark 7', 'Mark 8', 'Mark 9', 'Mark 10',
    'XJ220', 'XJ220 S', 'XJR-15', 'XJR-9', 'XJR-12',
    'SS100', 'SS Jaguar', 'F-Type Project 7', 'F-Type SVR', 'XKSS',
  ],

  'Maserati': [
    'Ghibli', 'Ghibli Trofeo', 'Quattroporte', 'Quattroporte Trofeo',
    'Levante', 'Levante Trofeo', 'Levante GT',
    'Grecale', 'Grecale GT', 'Grecale Trofeo', 'Grecale Folgore',
    'GranTurismo', 'GranTurismo Trofeo', 'GranTurismo Folgore',
    'GranCabrio', 'GranCabrio Folgore',
    'MC20', 'MC20 Cielo', 'MC20 Folgore',
    'Bora', 'Merak', 'Merak SS',
    'Biturbo', 'Biturbo Spider', '228i',
    'Shamal', 'Ghibli (1966)', 'Ghibli Spyder (1966)',
    'Indy', 'Khamsin', 'Kyalami',
    'Spyder (2001)', 'Coupe (2001)',
    '3500 GT', '3500 GTI', 'Mistral',
    'Sebring', 'Mexico', 'A6 GCS',
    '250F', '450S', '4200 GT', '4200 Spyder',
    'GranSport', 'MC12', 'Alfieri (concept)',
  ],

  'Alfa Romeo': [
    'Giulia', 'Giulia Quadrifoglio', 'Giulia GTA', 'Giulia GTAm',
    'Stelvio', 'Stelvio Quadrifoglio', 'Tonale', 'Tonale PHEV',
    'Junior', 'Junior Veloce', 'Junior Elettrica',
    '4C', '4C Spider', '8C Competizione', '8C Spider',
    'Brera', 'Brera S', 'Spider (939)',
    'Mito', 'Giulietta', 'Giulietta QV', 'Giulietta Sprint',
    '156', '156 GTA', '147', '147 GTA', '166', '159', '159 TI',
    '145', '146', 'GTV', 'GTV 6', 'GT', 'GT Cloverleaf',
    'Giulia (1962)', 'Giulia Sprint GT', 'Giulia Sprint GTA',
    'Giulia Super', 'Giulia TI Super',
    'Montreal', '33 Stradale', 'Tipo 33',
    'Alfasud', 'Alfasud Sprint', 'Alfasud TI',
    'Alfetta', 'Alfetta GT', 'Alfetta GTV',
    '1900', '2000', '2600',
    'Duetto Spider', 'Spider Series 1', 'Spider Veloce',
    'Tipo 158 Alfetta (F1)', 'Tipo 159',
    '8C 2300', '8C 2900', 'P3 (Tipo B)', 'Bimotore',
    'Sprint Speciale', 'Sprint Zagato',
    'TZ1', 'TZ2', 'Giulia TZ',
    'SZ', 'RZ', '75 (Milano)', '75 Turbo Evoluzione',
    'GTA 1300 Junior', 'GTA Junior', '155 V6 TI DTM',
  ],

  'Lincoln': [
    'Navigator', 'Navigator L', 'Aviator', 'Aviator Grand Touring',
    'Corsair', 'Corsair Grand Touring', 'Nautilus',
    'MKZ', 'MKZ Hybrid', 'MKC', 'MKT', 'MKX', 'MKS',
    'Town Car', 'Town Car Signature', 'Town Car Cartier',
    'Continental', 'Continental Mark Series',
    'Blackwood', 'LS', 'Zephyr',
    'Mark III', 'Mark IV', 'Mark V', 'Mark VI', 'Mark VII', 'Mark VIII',
    'Capri', 'Versailles', 'Premiere', 'Cosmopolitan',
    'Continental Mark II', 'Continental Convertible',
    'Model K', 'KB', 'KA',
    'Town Car Stretched Limo',
    'Continental Suicide Door (4th gen)',
    "Mark V Collector's Series",
  ],

  'Suzuki': [
    'Swift', 'Swift Sport', 'Baleno', 'Ignis', 'Celerio', 'Alto',
    'Jimny', 'Jimny Sierra', 'Jimny LCV',
    'Vitara', 'Vitara S', 'S-Cross', 'Across',
    'Grand Vitara', 'XL7', 'SX4', 'SX4 S-Cross',
    'Kizashi', 'Forenza', 'Verona', 'Aerio', 'Esteem',
    'Samurai', 'Sidekick', 'X-90', 'Tracker', 'Cultus', 'Liana',
    'Carry', 'Every', 'Wagon R', 'Spacia',
    'Alto Lapin', 'Alto Works', 'Cappuccino',
    'LJ50', 'LJ80', 'SJ410', 'SJ413',
    'Mighty Boy (kei truck)', 'Fronte', 'Fronte Coupe',
  ],

  'Land Rover': [
    'Defender', 'Defender 90', 'Defender 110', 'Defender 130',
    'Defender Works V8', 'Defender Trophy Edition',
    'Discovery', 'Discovery Sport',
    'Range Rover', 'Range Rover SV', 'Range Rover SV Autobiography',
    'Range Rover Sport', 'Range Rover Sport SVR', 'Range Rover Sport SV',
    'Range Rover Velar', 'Range Rover Evoque',
    'Freelander', 'LR2', 'LR4',
    'Series I', 'Series II', 'Series IIA', 'Series III',
    'Range Rover Classic', 'Range Rover Classic CSK',
    'Discovery Series 1', 'Discovery Series 2',
    'Camel Trophy Editions',
    'Defender NAS (North American Spec)',
    'Defender 90 Soft Top', 'Defender 110 Station Wagon',
    'Range Rover Autobiography Ultimate',
    'Range Rover 3.5 V8 (1970)',
    'Discovery Camel Trophy',
    'Wolf (military spec)', 'Perentie (Australian military)',
  ],

  'Scion': [
    'xA', 'xB', 'xB (2nd gen)', 'tC', 'tC RS 1.0', 'tC RS 2.0', 'tC RS 3.0',
    'xD', 'iQ', 'FR-S', 'iM', 'iA', 'C-HR',
    'xB Release Series', 'xB Custom', 'tC Release Series',
    'FR-S Release Series', 'FR-S 10 Series',
    'iQ EV', 'Hako Coupe (concept)', 'Fuse (concept)',
  ],

  'Toyota': [
    'Corolla', 'Corolla Hatchback', 'Corolla Cross',
    'Camry', 'Camry XSE', 'Camry TRD',
    'Avalon', 'Avalon TRD',
    'GR86', 'GR Corolla', 'GR Corolla Circuit Edition', 'GR Corolla Morizo',
    'GR Supra', 'GR Supra A91', 'GR Supra MT',
    'Yaris', 'Yaris GR', 'Yaris GR Four',
    'Prius', 'Prius Prime', 'Prius V', 'Prius C', 'Prius AWD-e',
    'RAV4', 'RAV4 Prime', 'RAV4 Hybrid', 'RAV4 TRD', 'RAV4 Adventure',
    'Highlander', 'Highlander Hybrid',
    '4Runner', '4Runner TRD Pro', '4Runner TRD Off-Road',
    'Land Cruiser', 'Land Cruiser 70 Series', 'Land Cruiser 300',
    'FJ Cruiser', 'FJ Cruiser Trail Teams',
    'Sequoia', 'Tundra', 'Tundra TRD Pro', 'Tundra Capstone',
    'Tacoma', 'Tacoma TRD Pro', 'Tacoma Trailhunter',
    'Hilux', 'Hilux Revo', 'Sienna', 'Venza',
    'C-HR', 'Crown', 'Crown Signia', 'Crown Crossover',
    'bZ4X', 'bZ3', 'Mirai',
    'MR2', 'MR2 AW11', 'MR2 SW20', 'MR2 Spyder ZZW30',
    'Celica', 'Celica GT', 'Celica GT-Four', 'Celica All-Trac',
    'Celica GTO', 'Celica Supra',
    'Supra A70', 'Supra A80',
    'Matrix', 'Echo', 'Tercel', 'Paseo', 'Solara',
    'Starlet', 'Starlet EP91', 'Starlet GT Turbo',
    'Cressida', 'Century', 'Soarer',
    'Mark II', 'Mark II Tourer V', 'Mark II Grande',
    'Aristo', 'Chaser', 'Chaser Tourer V',
    'Altezza', 'Altezza RS200', 'Verossa',
    'Sprinter Trueno', 'Corolla Levin', 'AE86',
    'AE86 Trueno', 'AE86 Levin', 'AE92', 'AE101',
    'Cresta', 'Cresta Tourer V',
    'GT-One TS020', 'Supra JGTC', 'GR010 Hybrid',
    'Alphard', 'Vellfire', 'Fortuner', 'Innova',
    'Rush', 'Wigo', 'Calya', 'Yaris Cross',
    'Kluger', 'Granvia', 'HiAce', 'Coaster',
    'LiteAce', 'TownAce', 'MasterAce',
    'Sprinter', 'Corona', 'Corona Mark II',
    'Publica', 'Publica 800', '2000GT', 'Sports 800',
    'OPA', 'Ipsum', 'Picnic', 'Previa', 'Estima',
    'ist', 'Funcargo', 'Raum', 'WiLL VS',
    'Blade', 'Voltz', 'Brevis',
  ],

  'Honda': [
    'Civic', 'Civic Si', 'Civic Type R', 'Civic Type R Limited Edition',
    'Accord', 'Accord Hybrid', 'Accord Touring',
    'Insight', 'Clarity', 'Clarity Fuel Cell', 'Clarity PHEV',
    'Integra', 'Integra Type S',
    'CR-V', 'CR-V Hybrid', 'HR-V', 'BR-V', 'ZR-V',
    'Passport', 'Pilot', 'Pilot TrailSport',
    'Ridgeline', 'Odyssey', 'Element',
    'Fit', 'e', 'e:Ny1', 'Prologue',
    'NSX', 'NSX (1990)', 'NSX Type R', 'NSX-T',
    'NSX (2nd gen)', 'NSX Type S',
    'S2000', 'S2000 CR', 'S2000 Club Racer',
    'S660', 'S800', 'S500',
    'Prelude', 'Prelude Si', 'Prelude VTEC',
    'CRX', 'CRX Si', 'CRX Del Sol', 'CRX Mugen',
    'Accord Euro R', 'Accord Type R',
    'Beat', 'Today', 'Life', 'Life Dunk',
    'N-Box', 'N-Box Custom', 'N-One', 'N-WGN', 'N-Van',
    'Z (360)', 'Z (600)',
    'Acty', 'Acty Truck', 'Monkey', 'CT125 Hunter Cub',
    'Vamos', 'Capa', 'Logo',
    'Zest', 'Zest Spark', 'Crossroad', 'Avancier',
    'Inspire', 'Legend', 'Legend Coupe',
    'Jazz', 'City', 'City Turbo II',
    'Brio', 'Mobilio', 'Freed', 'Stream', 'Airwave', 'Stepwgn',
    'Spirior', 'FR-V', 'Edix',
    'Integra (DC2)', 'Integra Type R (DC2)', 'Integra Type R (DB8)',
    'Civic EK9 Type R', 'Civic EP3 Type R', 'Civic FN2 Type R',
    'Civic FD2 Type R',
    'CR-Z', 'CR-Z Alpha', 'Crosstour',
    'Ridgeline (1st gen)', 'Passport (Isuzu-based)',
    'EV Plus', 'HSV-010 GT',
    'Mugen Civic', 'Mugen NSX', 'Mugen RR',
    'RA272 (F1)', 'RA168E (F1 turbo)',
  ],

  'Ford': [
    'Mustang', 'Mustang GT', 'Mustang GT500', 'Mustang Mach 1',
    'Mustang Dark Horse', 'Mustang GTD',
    'Mustang Mach-E', 'Mustang Mach-E GT', 'Mustang Mach-E Rally',
    'F-150', 'F-150 Raptor', 'F-150 Raptor R', 'F-150 Tremor',
    'F-150 Lightning', 'F-150 Lightning Pro',
    'F-250 Super Duty', 'F-350 Super Duty', 'F-450', 'F-550',
    'Ranger', 'Ranger Raptor',
    'Maverick', 'Maverick Tremor',
    'Explorer', 'Explorer ST', 'Explorer Timberline',
    'Expedition', 'Expedition Timberline',
    'Edge', 'Edge ST', 'Escape', 'Escape PHEV', 'EcoSport',
    'Bronco', 'Bronco Raptor', 'Bronco Heritage', 'Bronco Wildtrak',
    'Bronco Sport', 'Bronco Sport Badlands',
    'GT', 'GT40', 'GT40 Mk1', 'GT40 Mk2', 'GT40 Mk3', 'GT40 Mk4',
    'GT (2005)', 'GT (2017)', 'GT Le Mans',
    'RS200', 'RS200 Evolution',
    'Sierra RS Cosworth', 'Escort RS Cosworth',
    'Focus RS', 'Focus ST', 'Focus RS500',
    'Fiesta ST', 'Fiesta RS WRC',
    'Thunderbird', 'Thunderbird Super', 'Thunderbird Turbo Coupe',
    'Fairlane', 'Fairlane Cobra', 'Fairlane Thunderbolt',
    'Galaxie', 'Galaxie 500', 'Galaxie 500XL',
    'LTD', 'Crown Victoria', 'Crown Victoria Police Interceptor',
    'Ranchero', 'Ranchero GT', 'Ranchero 500',
    'Torino', 'Torino Cobra', 'Torino GT', 'Torino Talladega',
    'Maverick (classic)', 'Maverick Grabber',
    'Contour', 'Contour SVT', 'Tempo', 'Escort', 'Escort GT',
    'Aspire', 'Festiva', 'Pinto', 'Probe', 'Probe GT',
    'Fusion', 'Fusion Sport', 'Fusion Hybrid', 'Taurus', 'Taurus SHO',
    'Taurus SHO (1989)', 'Five Hundred',
    'Focus', 'Focus ZX5', 'Focus SVT', 'Freestyle',
    'Flex', 'Excursion', 'Freestar', 'Windstar', 'Aerostar',
    'Transit', 'Transit Connect', 'E-Series Van',
    'Puma', 'Puma ST', 'Kuga', 'Kuga ST-Line',
    'Mondeo', 'Mondeo ST220', 'Galaxy', 'S-Max', 'S-Max ST',
    'C-Max', 'C-Max Energi', 'B-Max', 'Ka', 'Ka+',
    'Territory', 'Everest', 'Endeavour',
    'Mustang Boss 302', 'Mustang Boss 429', 'Mustang Boss 351',
    'Mustang Shelby GT350', 'Mustang Shelby GT350R',
    'Mustang Shelby GT500 (1967)', 'Mustang Shelby GT500KR',
    'Mustang Cobra Jet', 'Mustang SVT Cobra', 'Mustang Bullitt',
    'F-100', 'F-100 Eluminator',
    'Bronco (1966)', 'Bronco (original)',
    'Cortina', 'Capri', 'Capri RS2600', 'Capri RS3100',
    'Cortina Lotus', 'Anglia', 'Anglia 105E',
    'Pop (Popular)', 'Prefect', 'Pilot',
    'Zephyr', 'Zephyr Zodiac', 'Consul',
    'C100 (Le Mans prototype)',
    'Bantam BRC (military Jeep)'],
  };

  final List<String> _years = List.generate(37, (index) => (2026 - index).toString());

  Future<void> _handleSignUp() async {
    if (_selectedMake == null || _selectedModel == null || _selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your car make, model and year')),
      );
      return;
    }

    setState(() { _isSigningUp = true; });
    bool success = await api.registerUser(widget.username, widget.password);
    setState(() { _isSigningUp = false; });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered! Please login now.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Username may exist.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Car Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Car:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Car Make',
                border: OutlineInputBorder(),
              ),
              value: _selectedMake,
              items: _carModels.keys.map((make) {
                return DropdownMenuItem(value: make, child: Text(make));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMake = value;
                  _selectedModel = null;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Car Model',
                border: OutlineInputBorder(),
              ),
              value: _selectedModel,
              items: _selectedMake == null
                  ? []
                  : _carModels[_selectedMake]!.map((model) {
                      return DropdownMenuItem(value: model, child: Text(model));
                    }).toList(),
              onChanged: _selectedMake == null
                  ? null
                  : (value) {
                      setState(() { _selectedModel = value; });
                    },
              hint: Text(_selectedMake == null ? 'Select make first' : 'Select model'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              value: _selectedYear,
              items: _years.map((year) {
                return DropdownMenuItem(value: year, child: Text(year));
              }).toList(),
              onChanged: (value) {
                setState(() { _selectedYear = value; });
              },
            ),
            const SizedBox(height: 32),
            if (_isSigningUp)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  child: const Text('SIGN UP'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}