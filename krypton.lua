--[[
    KRYPTON LAUNCHER - Loader UI (LocalScript unique)  |  v1.8.7
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Correction spécifique pour Delta et les autres executors mobiles
local globalRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request) or (Krnl and Krnl.request)

---------------------------------------------------------------------
-- CONFIG
---------------------------------------------------------------------
local Config = {
	Name = "Krypton",
	Subtitle = "LAUNCHER",
	DefaultLanguage = "FR",
	DiscordLink = "https://discord.gg/QrwXuueSA5",
	DiscordCode = "QrwXuueSA5",
	LogoFile = "",
	LogoImage = "rbxassetid://0",
	DiscordFile = "",
	DiscordImage = "rbxassetid://0",
	ApiBaseUrl = "https://krypton-dm2t.onrender.com",
	LoginPath = "/api/login",
	RegisterPath = "/api/register",
	KeyFile = "krypton_license.json",
	LangFile = "krypton_lang.txt",
	ProfilesFile = "krypton_profiles.json",
	CheckUsername = false,
	SupportedGames = { "urban reload", "one state" },
	SupportedPlaceIds = {},
}

local Lang = {
	EN = {
		welcome = "Welcome back", sub = "Enter your details to continue.",
		subSignup = "Create your account.",
		userPh = "Username", passPh = "Password",
		remember = "Remember me",
		signin = "Sign in", signup = "Sign up", verifying = "Verifying...", granted = "Access granted",
		emptyUser = "Please enter your username.", emptyPass = "Please enter your password.",
		shortPass = "Password must be at least 4 characters.",
		badCreds = "Invalid username or password.", userTaken = "This username is already taken.",
		noAccount = "No account found with this username.",
		expired = "Account expired.",
		hwid = "This account is linked to another device.",
		device_limit = "An account already exists on this device or network.",
		no_hwid = "Device ID not detected.",
		rate = "Too many requests. Please slow down.",
		copied = "Link copied to clipboard.",
		dashLoading = "Loading...", dashReady = "Ready",
		gameSupported = "Game supported", gameUnsupported = "Game not supported",
		license = "STATUS", expires = "EXPIRES", lifetime = "Lifetime", days = " days",
		expiresAt = "Expires at: ", expiresOn = "Expires on: ", comingSoon = "Coming soon",
		language = "Language", chooseLang = "Choose the menu language",
		stepLicense = "Checking account", stepGame = "Loading game", stepMenu = "Preparing menu",
		previewTitle = "ESP Preview", playersLbl = "Players",
		lblUser = "USER", lblKey = "KEY", lblDEVICE = "DEVICE",
		optDistance = "Draw Distance", snapTop = "Top", snapBottom = "Bottom",
		resetHwid = "Reset HWID", resetDesc = "Unlink this account from your current device.",
		resetBtn = "Reset", resetConfirm = "Confirm?", resetting = "Resetting...", resetOk = "Done ✓", resetFail = "Failed",
		optEnable = "Enable ESP", optBoxes = "Draw Boxes", optSnaplines = "Draw Snaplines",
		optSkeleton = "Draw Skeleton", optNames = "Draw Names", optHealth = "Draw Health",
		optArmor = "Draw Armor", optWeapon = "Draw Enemy Weapon", optCount = "Show Player Count",
		comingSoonTitle = "Coming soon",
		adminAlertTitle = "Enable Admin Alert",
		adminAlertDesc = "Alerts you when an administrator joins or is present.",
		catVisuals = "Visuals", catAssist = "Assistance", catPlayer = "Player", catFarm = "Farm", catMisc = "Misc", catCustom = "Customize",
		subGeneral = "General", subAdvanced = "Advanced",
		subSettings = "Settings", subProfils = "Profiles", subTranslation = "Translation",
		settingsTitle = "Settings",
		profilesCount = "Saved Profiles (%d/10)",
		newProfileName = "New Profile",
		toastCreated = "CREATED", toastSaved = "SAVED", toastLoaded = "LOADED", toastRenamed = "RENAMED", toastDeleted = "DELETED", toastReset = "RESET",
		noRequest = "Executor HTTP request not supported.",
		errServer = "Server communication error.",
		getKeyBtn = "Join the Discord",
	},
	FR = {
		welcome = "Bon retour", sub = "Entre tes informations pour continuer.",
		subSignup = "Crée ton compte.",
		userPh = "Nom d'utilisateur", passPh = "Mot de passe",
		remember = "Se souvenir de moi",
		signin = "Connexion", signup = "Inscription", verifying = "Vérification...", granted = "Accès autorisé",
		emptyUser = "Entre ton nom d'utilisateur.", emptyPass = "Entre ton mot de passe.",
		shortPass = "Le mot de passe doit faire au moins 4 caractères.",
		badCreds = "Nom d'utilisateur ou mot de passe incorrect.", userTaken = "Ce nom d'utilisateur est déjà pris.",
		noAccount = "Aucun compte avec ce nom d'utilisateur.",
		expired = "Compte expiré.",
		hwid = "Ce compte est lié à un autre appareil.",
		device_limit = "Un compte existe déjà sur cet appareil ou ce réseau.",
		no_hwid = "Identifiant d'appareil non détecté.",
		rate = "Trop de requêtes. Veuillez patienter.",
		copied = "Lien copié dans le presse-papiers.",
		dashLoading = "Chargement...", dashReady = "Prêt",
		gameSupported = "Jeu supporté", gameUnsupported = "Jeu non supporté",
		license = "STATUT", expires = "EXPIRE", lifetime = "Lifetime", days = " j",
		expiresAt = "Expire dans : ", expiresOn = "Expire le : ", comingSoon = "Bientôt disponible",
		language = "Langue", chooseLang = "Choisis la langue du menu",
		stepLicense = "Vérification du compte", stepGame = "Chargement du jeu", stepMenu = "Préparation du menu",
		previewTitle = "Aperçu ESP", playersLbl = "Joueurs",
		lblUser = "UTILISATEUR", lblKey = "CLÉ", lblDEVICE = "APPAREIL",
		optDistance = "Afficher la distance", snapTop = "Haut", snapBottom = "Bas",
		resetHwid = "Réinitialiser le HWID", resetDesc = "Délie ce compte de ton appareil actuel.",
		resetBtn = "Réinitialiser", resetConfirm = "Confirmer ?", resetting = "En cours...", resetOk = "Fait ✓", resetFail = "Échec",
		optEnable = "Activer l'ESP", optBoxes = "Afficher les boîtes", optSnaplines = "Afficher les lignes",
		optSkeleton = "Afficher le squelette", optNames = "Afficher les noms", optHealth = "Afficher la vie",
		optArmor = "Afficher l'armure", optWeapon = "Afficher l'arme ennemie", optCount = "Afficher le nombre de joueurs",
		comingSoonTitle = "Bientôt disponible",
		adminAlertTitle = "Activer l'alerte admin",
		adminAlertDesc = "Vous avertit lorsqu'un administrateur rejoint ou est présent.",
		catVisuals = "Visuels", catAssist = "Assistance", catPlayer = "Joueur", catFarm = "Farm", catMisc = "Misc", catCustom = "Personnaliser",
		subGeneral = "Général", subAdvanced = "Avancé",
		subSettings = "Paramètres", subProfils = "Profils", subTranslation = "Traduction",
		settingsTitle = "Paramètres",
		profilesCount = "Profils sauvegardés (%d/10)",
		newProfileName = "Nouveau Profil",
		toastCreated = "CRÉÉ", toastSaved = "SAUVEGARDÉ", toastLoaded = "CHARGÉ", toastRenamed = "RENOMMÉ", toastDeleted = "SUPPRIMÉ", toastReset = "RÉINITIALISÉ",
		noRequest = "Requête HTTP non supportée par l'executor.",
		errServer = "Erreur de communication avec le serveur.",
		getKeyBtn = "Rejoindre le Discord",
	},
}

local currentLang = Config.DefaultLanguage

local function alive(o)
	return o ~= nil and o.Parent ~= nil and o:IsDescendantOf(game)
end

local function saveLang()
	if writefile then pcall(writefile, Config.LangFile, currentLang) end
end
do
	local ok, v = pcall(function()
		if isfile and isfile(Config.LangFile) and readfile then return readfile(Config.LangFile) end
	end)
	if ok and (v == "FR" or v == "EN") then currentLang = v end
end

local function S(key) return Lang[currentLang][key] or Lang.EN[key] or key end

local Settings = {
	Visuals = {
		enable = false, boxes = false, snaplines = false, skeleton = false,
		names = false, distance = false, health = false, armor = false, weapon = false, count = false,
		snapPos = "Bottom",
		adminAlert = false,
	},
}
pcall(function() if getgenv then getgenv().KryptonSettings = Settings end end)

local Authed = false
local Session = { password = "" }

---------------------------------------------------------------------
-- THEME
---------------------------------------------------------------------
local C = {
	bg = Color3.fromRGB(10, 10, 11),
	panel = Color3.fromRGB(17, 17, 19),
	field = Color3.fromRGB(19, 19, 21),
	stroke = Color3.fromRGB(38, 38, 43),
	tabBg = Color3.fromRGB(14, 14, 16),
	tabSel = Color3.fromRGB(28, 28, 32),
	text = Color3.fromRGB(255, 255, 255),
	muted = Color3.fromRGB(120, 120, 128),
	err = Color3.fromRGB(255, 99, 99),
	good = Color3.fromRGB(110, 231, 140),
	discord = Color3.fromRGB(88, 101, 242),
}

---------------------------------------------------------------------
-- DÉCODEUR BASE64 & CHARGEMENT DES ASSETS (v1.8.7)
---------------------------------------------------------------------
local function b64decode(data)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local lookup = {}
	for i = 1, #chars do lookup[string.byte(chars, i)] = i - 1 end
	local out, n, buf, bits = {}, 0, 0, 0
	for i = 1, #data do
		local v = lookup[string.byte(data, i)]
		if v then
			buf = buf * 64 + v
			bits += 6
			if bits >= 8 then
				bits -= 8
				local p = 2 ^ bits
				local byte = math.floor(buf / p)
				buf = buf % p
				n += 1
				out[n] = string.char(byte)
			end
		end
	end
	return table.concat(out)
end

local EMBED_ICONS = {
	k = "iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAABGJUlEQVR42u29eZwV5Zkv/jzvW1VnX3oDGpAdgcYFUGYFG+OCCuzoysZkZYzITJzHrLPd3M/PJLNf25M5kbu6dGDcmyczExGQ0uEddl0RAtUGNzJSgqKoaJioqiKCqqA4qCICqqI2aWjTMRJ7NlJgZ3vOuekS132zGZzWb23n3vT1fn25v61Tvv3Hvv+x9M5+cFAwAYBwA=",
	download = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAClElEQVR42u2Xz0tUURTHv2cmpRDlRtB0JSiMEBEtWko/kGgh+Bckgrv+A6Wd/4H9B9GybNlG0E2ltg/pB7YQWwqF0rxm5tPmXDw9ZsZxRoXAA5f73jnnfs+Pd+6590n/MwFDwNBFGzWfZzimmSg7bwfKPh8ANR8HUXYaynrw5VBSycdhtyC9OFBq8XxhDpwJXTpw6UD5FHs/k1TvQDdtzYaZ1Xp2ALAIBPS1y6iZ5clRX0tXnyC01TKwAnwGFswsd1lsu+bGcmDBdVdSgF216BQpsBh6/m9gyfl7gb/nvCXXSbR4UtY6qYEBn3NJfZKWgf3C2jIwL2nZM5N0B3o5dDKfh4E1j6jGyZR01oDhiNWNEyWfx4FNB663MZ5km8B4xDh19EDJRx9gwASw1SYTibfluuZrE07WiWFr57EDbzdxIj1vAxPtMlrcEdZCcUzSuKSGN5Ufkj6ZGcCkpBeS7kr640uuSPooac7MdtzITUk3vCdkkr6Z2fd2kRtwDXgCvC+kdw+YDvoVYCPIN4BKkD8C9gsY74A5t2H/ZCLc82YLe74KHPr7F+B+cHgEeO5jJGA8AL76ml+OcxRwZ5s2J2AQ+ODKecH79L4TM9Ekk9OuE9fUw/uR2xhsFn2lsJAWTuwCy8BowBh13q7rVH1eBeaBtwV+JdmO3awuqdqqML3Q6pLGJD2TdA/YcdmkpCl/rnkXlKRVM3sJXJf02HnVeKqWCxfL/lDZrS6iDR9TwWgynDkmHshT4Jak+Nn6m15ivTpfeZryDltu7qOTFp17Qa56Ro77AJCZWcOrfD1EaR5NL5QwMh8PzWw92Sz2gjJwB3jD2dNr4LbbsJM64VU/SmlTlB0fLY7x08yOOv75PM8f20h/Af8jRK8WiGYlAAAAAElFTkSuQmCC",
	save = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABF0lEQVR42u2XvQ3CMBCFP1MhKJghiAYEuwTRIwoWoM0c7AE9UgRiBxiADRC/lWkMioITHEMc/p50jX05X957sWMhpaRIlCgYugYGwA6QT0Zg0oCISZCHHl1gasLAICeWJ4BvwsAOqOYot5aJKANJi2+AOiAMo66e0THRuxuVUl4jCV4kxzS8lHp+NDcqQZIBhSXlaYYWRe8Dgc6ELhm41X3LnTCOhkVd75UNhFkKqtylabKJB/LC53jg30CaOTsqQmsjWJqwDJxjYxVg78KEoWZxgAOwcMFAC1gnzDWB1dd/hmPLue8xIcAJmAFtpfs84+JaBo7qzVxgC9TiDAwdem/k8mKS6Z9QAH1bPR9gr2qLtKvZ752GF/Zjy5uWt2lXAAAAAElFTkSuQmCC",
	pencil = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACpklEQVR42rWXsU8UURDGv7k7sCAxGBI1scAYOyo5DgiclxBRE0ob/wf9t8DCylgaOy3UaGEsTDQRExHEABqCEe5u92czLz43d+fe3jLN7L59+76Z+WZmZ6VTEKDaY80Ay67bKYCPmVkHmJI07ctHZvbBn1fMLNUpeT7mugE85a8cAfeBs/0iVFrYgSZw4MC/gRMg9fsNYNLpqJQJXnF9A/gKJA4cJL5fB6aAailGhOQCJoAnkedZSYFjv74X3i0zCjVgGXjvIN0eRiS+fgBcHdlz1zPAWrTeAD4OMCJQMVdGws26V3vAzej5AvCpjxGBhmtllFqcaN+AW9G+OWAzY0TY/ww4P3QOAOOuF722k4hXvAJuR/vnIyOOoz0zQ/eDyPMmsO+gSRSBjuutjBEN4F30rFUEvOa6Bew4cKdHgoW1LxkjmsBDYCU+b9gmswxsZ4B6SaBjB1iNzpkoAm4Rl7s5wLNG7ANr0TmVIuB14HBAXdOn6wWZGbrrRXVej0DTnOBh/yEwW6il9qjzvOCBnl1gfhTPQ52nmVLLA74NLBfhvOZftYa31mRI8MQzv1Uo2/37fAZ47Ie2c4KHTrgPNOOmVYT3u8APb5tpTvDU6VqM23VeqWSG0yuSJnMOrPj7HUkrZvbCB9L2MAbUfErtAOckLfjB1RzgJimRtGRmb4CqmXVG+bZfd97T/4Q/rvP6qKNVJQr1BUljktoDwt/26HyXtOqem5lR2AAz63oSzmbyIoS6K+nE9bikLUl3zOyV01cYPKZh2geH1Gu67ZWQ7QMbwFKucidgAkipwAAAABJRU5ErkJggg==",
	trash = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAByklEQVR42s2XvYoUQRSFv9PTg6AIwpiIgQhGYmbgI/kOgmhmYCK+gIFPYSRrooqmpoLvDsoEauLisO870HAOrooBn6p2qmhvVA0U11172nTt17+zYkwnaV+N6EDCjVulaS17XvADHDP2nNJH21LkrMJ2BYw3ZgXMAFuA++BayM2HwCfosm2eWCZSqxLhRf+hzPbi45xlsntl+032EbQkngFPgVvAOjyvwv194EZY1xUPcWcnwLvWunhcJ8BjSYfRX3t3lelfiLiWfYKdnUBeo4uW0QCYy5aYx+CgwEaE6ZcMvS99z1UaW26TqZp+H0iWjH+A3b1w0W/gO8CqUACyCdwKagbID7G2vYgPsh8l3gV1wXyL03E7J43a3Qj9gOQ8n4Mh+p7rI4VNgOthTIN6C7C1l9W4HjAP/6l2g+aD7i9gCj0CgC29BfwB16oXU6Z9yAHvC6U8g953G+4bZfO3V8eYj2oH8YmO76D1aL7yGf3+B3cO3A3g4wN373w9n83u22Q08mPchvT/wHkXv3X1p0d6cAAAAAElFTkSuQmCC",
	eraser = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACpklEQVR42s2XPWsUURSG37MfiSIqEiutxFKDCKJgIUJAAoqdlX9BGxX8IFFBsRB/hI1lCmPiZ2eprY2NhY1RCJGgxmxm9rE5V4+Tye5OdhO9MMzszp1z3nvOc8+9V/rHzfo1ANQlNSS1JWVmxqapBxqF3zXANjWEwBjwCLgehWykQwvPM8ACf9o74FBZdAblvOb3LcCz4LgFtP15CTgQ+Bicc6ABbAOmSxwDZH7/AYwOLBKAAXWgCUwF52Ut92sBONa3CHeeQj/rTlbo3DK/5oKIer/Avegy8jIRAJ8CmPX1ANcIwC0Vct6riMVKTDhwNQduxo38DIariMdD991FeM4bPtUScMt+/w58KxjuVUTbI3FkzXQk2v35cSHnX4EzwAWHMF9HOnLgM3A8Teu1gHteGPkicDKIvBTyWyUSKY1THuFamfMIHB7yMX83lFQDl0MEqopYBk4Vc74DeFLifNz7NUN/CyKyimCuEpAMPyg4XwROd6PW05FKcr7eFIwCHwJcH4GznZwXgL3iIvIOIhKEXxxC+20bOBcWEYCnvRSNaCSko12SjjgDz67aMwB7gbfeqeXz/W6ohNajiKsexXYJoOWFKDBwscAAwO1Af68iJiqX4vDxzZCKpPxWNxGBhV1hr5BWzDngcNfFKBiZDEUohHHS3w27kHQ1E83A7rBippHPAyd8L7HV+w+tyVZJGPNgbLKD+O3Ay1C6M+A9sK/yuQAYMrMWMCHpjqTMXzUkvS75vi1pRNJBSbmkmv8/L+mNpJ2SVvy/zO3Mmtn9TkAlMG+UANWpyLQ8971sWsbTqP4ekllyVjeze8CwpPOS9neJ5nCFzVYmaanr0QyomVkbGJF0TdKePve3KQWvzOxhlbPfhh1wrELn5gAOs7iN3Mwy/Q/tF7d34LDg2UOdAAAAAElFTkSuQmCC",
}

local customAsset = getcustomasset or getsynasset
local function resolveImage(file, id, embedded, embeddedName)
	if file and file ~= "" and customAsset and isfile then
		local ok, res = pcall(function()
			if isfile(file) then return customAsset(file) end
		end)
		if ok and res then return res end
	end
	if id and id ~= "" and id ~= "rbxassetid://0" then return id end
	if customAsset and isfile then
		local ok, res = pcall(function()
			if isfile(embeddedName) then return customAsset(embeddedName) end
		end)
		if ok and res then return res end
	end
	if embedded and embedded ~= "" and writefile and customAsset then
		local ok, res = pcall(function()
			writefile(embeddedName, b64decode(embedded))
			return customAsset(embeddedName)
		end)
		if ok and res then return res end
	end
	return nil
end

local LogoAsset = resolveImage(Config.LogoFile, Config.LogoImage, "", "krypton_logo_v18.png")
local DiscordAsset = resolveImage(Config.DiscordFile, Config.DiscordImage, "", "krypton_discord.jpg")

local IconAssets = {}
for _, name in ipairs({ "eye", "aim", "user", "farm", "gear", "palette" }) do
	IconAssets[name] = resolveImage("", "", "", "krypton_ico_" .. name .. "_v3.png")
end
IconAssets.k = resolveImage("", "", EMBED_ICONS.k, "krypton_ico_k_v3.png")
IconAssets.download = resolveImage("", "", EMBED_ICONS.download, "krypton_ico_download_v3.png")
IconAssets.floppy = resolveImage("", "", EMBED_ICONS.save, "krypton_ico_save_v3.png")
IconAssets.pencil = resolveImage("", "", EMBED_ICONS.pencil, "krypton_ico_pencil_v3.png")
IconAssets.trash = resolveImage("", "", EMBED_ICONS.trash, "krypton_ico_trash_v3.png")
IconAssets.plus = resolveImage("", "", EMBED_ICONS.plus, "krypton_ico_plus_v3.png")
IconAssets.eraser = resolveImage("", "", EMBED_ICONS.eraser, "krypton_ico_eraser_v3.png")

---------------------------------------------------------------------
-- HELPERS DE CONSTRUCTION & SÉCURITÉ AUTOLOCALIZE
---------------------------------------------------------------------
local function applyAutoLocalize(o)
	pcall(function()
		if o:IsA("GuiObject") or o:IsA("LayerCollector") or o:IsA("CoreGui") then
			o.AutoLocalize = false
		end
	end)
end

local function new(class, props, parent)
	local o = Instance.new(class)
	applyAutoLocalize(o)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function setupGuiProtection(guiInst)
	applyAutoLocalize(guiInst)
	for _, d in ipairs(guiInst:GetDescendants()) do applyAutoLocalize(d) end
	guiInst.DescendantAdded:Connect(applyAutoLocalize)
end

local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function cornerS(o, s) return new("UICorner", { CornerRadius = UDim.new(s, 0) }, o) end
local function stroke(o, col, th, tr)
	return new("UIStroke", { Color = col, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end
local function tween(o, t, p, style, dir)
	TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), p):Play()
end
local function label(parent, text, size, pos, sz, color, font, alignX)
	return new("TextLabel", {
		BackgroundTransparency = 1, Text = text, TextSize = size,
		Position = pos, Size = sz, TextColor3 = color or C.text,
		Font = font or Enum.Font.GothamMedium, TextXAlignment = alignX or Enum.TextXAlignment.Left,
	}, parent)
end
local function holder(parent, x, y, w, h, clip)
	return new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
		BackgroundTransparency = 1, ClipsDescendants = clip or false,
	}, parent)
end
local function ring(parent, x, y, w, h, r, color, th)
	local f = new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h), BackgroundTransparency = 1,
	}, parent)
	corner(f, r)
	stroke(f, color, th or 1.5)
	return f
end

local function typeText(lbl, text)
	local id = (lbl:GetAttribute("tid") or 0) + 1
	lbl:SetAttribute("tid", id)
	task.spawn(function()
		local n = utf8.len(text) or #text
		for i = 1, n do
			if lbl:GetAttribute("tid") ~= id then return end
			local e = (utf8.offset(text, i + 1) or (#text + 1)) - 1
			lbl.Text = string.sub(text, 1, e)
			task.wait(0.022)
		end
		if lbl:GetAttribute("tid") == id then lbl.Text = text end
	end)
end

local function makeParticles(parent, w, h, count)
	local ps = {}
	for i = 1, count do
		local s = math.random(2, 4)
		local f = new("Frame", {
			Size = UDim2.fromOffset(s, s), BackgroundColor3 = Color3.fromRGB(200, 200, 210),
			BorderSizePixel = 0, BackgroundTransparency = 1,
		}, parent)
		corner(f, 2)
		ps[i] = { f = f, x = math.random(0, w), y = math.random(0, h), v = math.random(10, 32), sw = math.random() * 6, a = math.random(4, 12), max = math.random(55, 85) / 100 }
	end
	local t = 0
	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		if not alive(parent) then conn:Disconnect() return end
		t += dt
		for _, p in ipairs(ps) do
			p.y -= p.v * dt
			if p.y < -6 then p.y = h + 6; p.x = math.random(0, w) end
			p.f.Position = UDim2.fromOffset(p.x + math.sin(t + p.sw) * p.a, p.y)
			local edge = math.min(p.y / h, (h - p.y) / h) * 4
			p.f.BackgroundTransparency = 1 - math.clamp(edge, 0, 1) * (1 - p.max)
		end
	end)
end

local function makeDraggable(target, handle)
	local dragging, startPos, startMouse
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, startMouse, startPos = true, i.Position, target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - startMouse
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

---------------------------------------------------------------------
-- SQUELETTE PARTAGÉ (ESP & Aperçu) - V1.8.7 CORRIGÉ
---------------------------------------------------------------------
local SKELETON_BONES = {
	{ "Head", "Neck" },
	{ "Neck", "Chest" },
	{ "Chest", "Pelvis" },
	{ "Neck", "L_Shoulder" },
	{ "Neck", "R_Shoulder" },
	{ "L_Shoulder", "L_Elbow" },
	{ "L_Elbow", "L_Hand" },
	{ "L_Hand", "L_Tip" },
	{ "R_Shoulder", "R_Elbow" },
	{ "R_Elbow", "R_Hand" },
	{ "R_Hand", "R_Tip" },
	{ "Pelvis", "L_Hip" },
	{ "L_Hip", "L_Knee" },
	{ "L_Knee", "L_Foot" },
	{ "Pelvis", "R_Hip" },
	{ "R_Hip", "R_Knee" },
	{ "R_Knee", "R_Foot" },
}

local JOINT_NAMES = { "Head", "Neck", "Chest", "Pelvis", "L_Shoulder", "R_Shoulder", "L_Elbow", "R_Elbow", "L_Hand", "R_Hand", "L_Tip", "R_Tip", "L_Hip", "R_Hip", "L_Knee", "R_Knee", "L_Foot", "R_Foot" }

local function mkBone(parent, col)
	local shadow = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, BorderSizePixel = 0, Visible = false, ZIndex = 1 }, parent)
	cornerS(shadow, 0.5)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false, ZIndex = 2 }, parent)
	cornerS(f, 0.5)
	return f, shadow
end

local function mkJoint(parent, col, size)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size, size), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false, ZIndex = 3 }, parent)
	cornerS(f, 0.5)
	return f
end

local function setBoneLine(f, shadow, x1, y1, x2, y2, th)
	local dx, dy = x2 - x1, y2 - y1
	local len = math.sqrt(dx * dx + dy * dy)
	local pos = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
	local rot = math.deg(math.atan2(dy, dx))
	f.Position = pos
	f.Size = UDim2.fromOffset(len, th)
	f.Rotation = rot
	f.Visible = true
	if shadow then
		shadow.Position = pos
		shadow.Size = UDim2.fromOffset(len, th + 2)
		shadow.Rotation = rot
		shadow.Visible = true
	end
end

local function motorPos(modelOrChar, motorName)
	local m = modelOrChar:FindFirstChild(motorName, true)
	if m and m:IsA("Motor6D") and m.Part0 and m.Part1 then
		return (m.Part0.CFrame * m.C0).Position
	end
	return nil
end

local function getSkeletonPoints(modelOrChar)
	local points = {}
	local head = modelOrChar:FindFirstChild("Head")
	if head then points["Head"] = head.Position end

	local upperTorso = modelOrChar:FindFirstChild("UpperTorso")
	local lowerTorso = modelOrChar:FindFirstChild("LowerTorso")
	local torso = modelOrChar:FindFirstChild("Torso")

	if upperTorso then
		points["Chest"] = upperTorso.Position
		points["Pelvis"] = lowerTorso and lowerTorso.Position or upperTorso.Position - Vector3.new(0, 1, 0)
		points["Neck"] = motorPos(modelOrChar, "Neck") or (upperTorso.Position + Vector3.new(0, upperTorso.Size.Y / 2, 0))

		points["L_Shoulder"] = motorPos(modelOrChar, "LeftShoulder")
		points["R_Shoulder"] = motorPos(modelOrChar, "RightShoulder")
		points["L_Elbow"] = motorPos(modelOrChar, "LeftElbow")
		points["R_Elbow"] = motorPos(modelOrChar, "RightElbow")

		local lHandPart = modelOrChar:FindFirstChild("LeftHand") or modelOrChar:FindFirstChild("LeftLowerArm")
		local rHandPart = modelOrChar:FindFirstChild("RightHand") or modelOrChar:FindFirstChild("RightLowerArm")
		local lw = motorPos(modelOrChar, "LeftWrist") or (lHandPart and lHandPart.Position)
		local rw = motorPos(modelOrChar, "RightWrist") or (rHandPart and rHandPart.Position)
		points["L_Hand"] = lw
		points["R_Hand"] = rw
		if lHandPart then points["L_Tip"] = lHandPart.CFrame * Vector3.new(0, -lHandPart.Size.Y / 2, 0) else points["L_Tip"] = lw end
		if rHandPart then points["R_Tip"] = rHandPart.CFrame * Vector3.new(0, -rHandPart.Size.Y / 2, 0) else points["R_Tip"] = rw end

		points["L_Hip"] = motorPos(modelOrChar, "LeftHip")
		points["R_Hip"] = motorPos(modelOrChar, "RightHip")
		points["L_Knee"] = motorPos(modelOrChar, "LeftKnee")
		points["R_Knee"] = motorPos(modelOrChar, "RightKnee")

		local lFootPart = modelOrChar:FindFirstChild("LeftFoot") or modelOrChar:FindFirstChild("LeftAnkle")
		local rFootPart = modelOrChar:FindFirstChild("RightFoot") or modelOrChar:FindFirstChild("RightAnkle")
		points["L_Foot"] = motorPos(modelOrChar, "LeftAnkle") or (lFootPart and lFootPart.Position)
		points["R_Foot"] = motorPos(modelOrChar, "RightAnkle") or (rFootPart and rFootPart.Position)

		-- Fallbacks pour R15 si Motor6D manquants
		for _, name in ipairs(JOINT_NAMES) do
			if not points[name] then
				local pPart = modelOrChar:FindFirstChild(name == "L_Hand" and "LeftHand" or name == "R_Hand" and "RightHand" or name)
				if pPart then points[name] = pPart.Position end
			end
		end
	elseif torso then
		local tcf, tsz = torso.CFrame, torso.Size
		points["Neck"] = tcf * Vector3.new(0, tsz.Y / 2, 0)
		points["Chest"] = tcf.Position
		points["Pelvis"] = tcf * Vector3.new(0, -tsz.Y / 2, 0)
		points["L_Shoulder"] = tcf * Vector3.new(-tsz.X / 2, tsz.Y / 2 - 0.5, 0)
		points["R_Shoulder"] = tcf * Vector3.new(tsz.X / 2, tsz.Y / 2 - 0.5, 0)
		points["L_Hip"] = tcf * Vector3.new(-tsz.X / 4, -tsz.Y / 2, 0)
		points["R_Hip"] = tcf * Vector3.new(tsz.X / 4, -tsz.Y / 2, 0)

		for _, side in ipairs({ {"Left", "L"}, {"Right", "R"} }) do
			local arm = modelOrChar:FindFirstChild(side[1] .. " Arm")
			local leg = modelOrChar:FindFirstChild(side[1] .. " Leg")
			if arm then
				local acf, asz = arm.CFrame, arm.Size
				local hand = acf * Vector3.new(0, -asz.Y / 2, 0)
				points[side[2] .. "_Hand"] = hand
				points[side[2] .. "_Tip"] = hand - Vector3.new(0, 0.5, 0)
				points[side[2] .. "_Elbow"] = (points[side[2] .. "_Shoulder"] + hand) / 2
			end
			if leg then
				local lcf, lsz = leg.CFrame, leg.Size
				local foot = lcf * Vector3.new(0, -lsz.Y / 2, 0)
				points[side[2] .. "_Foot"] = foot
				points[side[2] .. "_Knee"] = (points[side[2] .. "_Hip"] + foot) / 2
			end
		end
	end
	return points
end

---------------------------------------------------------------------
-- ICONES & PICTOGRAMMES (ICÔNES CORRIGÉES V1.8.7)
---------------------------------------------------------------------
local Icons = {}

function Icons.lock(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 4.5, 0.5, 9, 10, 4.5, color, 1.6)
	cornerS(new("Frame", { Position = UDim2.fromOffset(2, 8), Size = UDim2.fromOffset(14, 9), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.2)
	return h
end

function Icons.key(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	local k = new("Frame", { Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Rotation = -45 }, h)
	ring(k, 0, 5.5, 7, 7, 3.5, color, 1.6)
	new("Frame", { Position = UDim2.fromOffset(6.5, 8.2), Size = UDim2.fromOffset(11, 1.7), BackgroundColor3 = color, BorderSizePixel = 0 }, k)
	new("Frame", { Position = UDim2.fromOffset(12.8, 9.9), Size = UDim2.fromOffset(1.7, 3.4), BackgroundColor3 = color, BorderSizePixel = 0 }, k)
	new("Frame", { Position = UDim2.fromOffset(15.8, 9.9), Size = UDim2.fromOffset(1.7, 2.6), BackgroundColor3 = color, BorderSizePixel = 0 }, k)
	return h
end

function Icons.user(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18, true)
	ring(h, 5, 1, 8, 8, 4, color, 1.7)
	ring(h, 1.5, 11, 15, 14, 7, color, 1.7)
	return h
end

function Icons.globe(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 1, 1, 16, 16, 8, color, 1.4)
	ring(h, 5.5, 1, 7, 16, 3.5, color, 1.2)
	new("Frame", { Position = UDim2.fromOffset(1, 8.5), Size = UDim2.fromOffset(16, 1), BackgroundColor3 = color, BorderSizePixel = 0 }, h)
	for _, yy in ipairs({ 4.5, 12.5 }) do
		new("Frame", { Position = UDim2.fromOffset(3, yy), Size = UDim2.fromOffset(12, 1), BackgroundColor3 = color, BackgroundTransparency = 0.4, BorderSizePixel = 0 }, h)
	end
	return h
end

function Icons.cross(parent, cx, cy, size, color)
	local h = new("Frame", {
		Position = UDim2.fromOffset(cx, cy), Size = UDim2.fromOffset(size, size), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}, parent)
	for _, rot in ipairs({ 45, -45 }) do
		cornerS(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size * 1.35, 2), Rotation = rot, BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 0.5)
	end
	return h
end

function Icons.check(parent, color)
	local h = holder(parent, 0, 0, 18, 18)
	h.Size = UDim2.fromScale(1, 1)
	cornerS(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(6.5, 10), Size = UDim2.fromOffset(6, 2),
		Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0,
	}, h), 0.5)
	cornerS(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(10.5, 8), Size = UDim2.fromOffset(10, 2),
		Rotation = -50, BackgroundColor3 = color, BorderSizePixel = 0,
	}, h), 0.5)
	return h
end

local function tintIcon(h, col)
	for _, d in ipairs(h:GetDescendants()) do
		if d:IsA("UIStroke") then
			tween(d, 0.15, { Color = col })
		elseif d:IsA("ImageLabel") then
			tween(d, 0.15, { ImageColor3 = col })
		elseif d:IsA("Frame") and d.BackgroundTransparency < 1 and not d:GetAttribute("Hole") then
			tween(d, 0.15, { BackgroundColor3 = col })
		end
	end
end

function Icons.eye(parent, x, y, color, slashed)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 0, 4, 18, 10, 5, color, 1.6)
	ring(h, 6, 6, 6, 6, 3, color, 1.5)
	cornerS(new("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(2, 2), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	if slashed then
		cornerS(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(22, 2),
			Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 0.5)
	end
	return h
end

-- Vecteurs de secours pour les icônes de profils
local function drawDownloadVector(h, col)
	local line = new("Frame", { Position = UDim2.fromOffset(8, 3), Size = UDim2.fromOffset(2, 8), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	local arrow1 = new("Frame", { Position = UDim2.fromOffset(5, 9), Size = UDim2.fromOffset(4, 2), Rotation = 45, BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	local arrow2 = new("Frame", { Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(4, 2), Rotation = -45, BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	local base = new("Frame", { Position = UDim2.fromOffset(3, 14), Size = UDim2.fromOffset(12, 2), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
end

local function drawSaveVector(h, col)
	local box = new("Frame", { Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	cornerS(box, 0.2)
	local inner = new("Frame", { Position = UDim2.fromOffset(5, 8), Size = UDim2.fromOffset(8, 5), BackgroundColor3 = C.panel, BorderSizePixel = 0 }, h)
end

local function drawPencilVector(h, col)
	local p = new("Frame", { Position = UDim2.fromOffset(7, 3), Size = UDim2.fromOffset(4, 12), Rotation = -45, BackgroundColor3 = col, BorderSizePixel = 0 }, h)
end

local function drawTrashVector(h, col)
	local lid = new("Frame", { Position = UDim2.fromOffset(4, 3), Size = UDim2.fromOffset(10, 2), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	local bin = new("Frame", { Position = UDim2.fromOffset(5, 6), Size = UDim2.fromOffset(8, 9), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	cornerS(bin, 0.2)
end

local function drawPlusVector(h, col)
	new("Frame", { Position = UDim2.fromOffset(3, 8), Size = UDim2.fromOffset(12, 2), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	new("Frame", { Position = UDim2.fromOffset(8, 3), Size = UDim2.fromOffset(2, 12), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
end

local function drawEraserVector(h, col)
	local e = new("Frame", { Position = UDim2.fromOffset(4, 6), Size = UDim2.fromOffset(10, 8), BackgroundColor3 = col, BorderSizePixel = 0 }, h)
	cornerS(e, 0.3)
end

local VECTOR_DRAWERS = {
	download = drawDownloadVector,
	save = drawSaveVector,
	pencil = drawPencilVector,
	trash = drawTrashVector,
	plus = drawPlusVector,
	eraser = drawEraserVector,
}

local function makeAssetIcon(assetKey, drawVectorFn)
	return function(parent, color)
		local h = holder(parent, 0, 0, 18, 18)
		h.AnchorPoint = Vector2.new(0.5, 0.5)
		h.Position = UDim2.fromScale(0.5, 0.5)
		local asset = IconAssets[assetKey]
		if asset then
			local img = new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Image = asset, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit }, h)
			local isLoaded = false
			img:GetPropertyChangedSignal("IsLoaded"):Connect(function()
				if img.IsLoaded then isLoaded = true end
			end)
			task.spawn(function()
				task.wait(2)
				if not isLoaded and alive(h) then
					img:Destroy()
					if drawVectorFn then drawVectorFn(h, color) end
				end
			end)
		else
			if drawVectorFn then drawVectorFn(h, color) end
		end
		return h
	end
end

Icons.download = makeAssetIcon("download", VECTOR_DRAWERS.download)
Icons.floppy = makeAssetIcon("floppy", VECTOR_DRAWERS.save)
Icons.pencil = makeAssetIcon("pencil", VECTOR_DRAWERS.pencil)
Icons.trash = makeAssetIcon("trash", VECTOR_DRAWERS.trash)
Icons.plus = makeAssetIcon("plus", VECTOR_DRAWERS.plus)
Icons.eraser = makeAssetIcon("eraser", VECTOR_DRAWERS.eraser)

---------------------------------------------------------------------
-- ICONES DU MENU
---------------------------------------------------------------------
local ACCENT = Color3.fromRGB(236, 239, 247)
local CAT_FONT = Enum.Font.Jura

local function fillDot(parent, x, y, s, color, isHole)
	local f = new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(s, s),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, parent)
	cornerS(f, 0.5)
	if isHole then f:SetAttribute("Hole", true) end
	return f
end

function Icons.hubEye(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	ring(h, 0.5, 3.5, 17, 11, 5.5, color, 2.2)
	fillDot(h, 5.2, 5.2, 7.6, color)
	fillDot(h, 7.4, 7.4, 3.2, holeCol, true)
	return h
end

function Icons.hubAim(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 3.5, 3.5, 11, 11, 5.5, color, 1.8)
	local function barI(bx, by, bw, bh)
		cornerS(new("Frame", { Position = UDim2.fromOffset(bx, by), Size = UDim2.fromOffset(bw, bh), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	end
	barI(8, 0, 2, 5.5)
	barI(8, 12.5, 2, 5.5)
	barI(0, 8, 5.5, 2)
	barI(12.5, 8, 5.5, 2)
	fillDot(h, 7.3, 7.3, 3.4, color)
	return h
end

function Icons.hubUser(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18, true)
	fillDot(h, 5.3, 0.8, 7.4, color)
	cornerS(new("Frame", { Position = UDim2.fromOffset(1.5, 10), Size = UDim2.fromOffset(15, 15), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	return h
end

function Icons.hubFarm(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 2, 2, 14, 14, 4, color, 1.5)
	cornerS(new("Frame", { Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(4, 8), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.2)
	cornerS(new("Frame", { Position = UDim2.fromOffset(4, 11), Size = UDim2.fromOffset(10, 3), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.2)
	return h
end

function Icons.hubGear(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	fillDot(h, 3.3, 3.3, 11.4, color)
	for k = 0, 7 do
		local a = k * math.pi / 4
		cornerS(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(9 + math.cos(a) * 7, 9 + math.sin(a) * 7),
			Size = UDim2.fromOffset(3.6, 4.2), Rotation = k * 45 + 90,
			BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 0.2)
	end
	fillDot(h, 6.6, 6.6, 4.8, holeCol, true)
	return h
end

function Icons.hubPalette(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	cornerS(new("Frame", { Position = UDim2.fromOffset(0.3, 1.3), Size = UDim2.fromOffset(17.4, 15.4), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	fillDot(h, 3.4, 6.4, 2.8, holeCol, true)
	fillDot(h, 6.8, 3.4, 2.8, holeCol, true)
	fillDot(h, 11.2, 3.6, 2.8, holeCol, true)
	fillDot(h, 13.8, 7.6, 2.8, holeCol, true)
	fillDot(h, 8.8, 10, 4.8, holeCol, true)
	return h
end

function Icons.previewSymbol(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	local screen = new("Frame", {
		Position = UDim2.fromOffset(1, 3), Size = UDim2.fromOffset(16, 11),
		BackgroundTransparency = 1,
	}, h)
	cornerS(screen, 0.25)
	stroke(screen, color, 1.4)
	fillDot(screen, 11, 3, 2, color)
	new("Frame", {
		Position = UDim2.fromOffset(7, 14), Size = UDim2.fromOffset(4, 2),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, h)
	new("Frame", {
		Position = UDim2.fromOffset(4, 16), Size = UDim2.fromOffset(10, 1),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, h)
	return h
end

local function imageIcon(assetName, fallback)
	return function(parent, x, y, color, holeCol)
		local asset = IconAssets[assetName]
		if not asset then return fallback(parent, x, y, color, holeCol) end
		local h = holder(parent, x, y, 18, 18)
		new("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
			Image = asset, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit,
		}, h)
		return h
	end
end

Icons.hubEye = imageIcon("eye", Icons.hubEye)
Icons.hubAim = imageIcon("aim", Icons.hubAim)
Icons.hubUser = imageIcon("user", Icons.hubUser)
Icons.hubFarm = imageIcon("farm", Icons.hubFarm)
Icons.hubGear = imageIcon("gear", Icons.hubGear)
Icons.hubPalette = imageIcon("palette", Icons.hubPalette)

do
	local fallbackEye = Icons.eye
	Icons.eye = function(parent, x, y, color, slashed)
		local asset = IconAssets.eye
		if not asset then return fallbackEye(parent, x, y, color, slashed) end
		local h = holder(parent, x, y, 18, 18)
		new("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
			Image = asset, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit,
		}, h)
		if slashed then
			cornerS(new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(22, 2),
				Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0,
			}, h), 0.5)
		end
		return h
	end
end

local function makeLogo(parent, size, pos, anchor)
	local h = new("Frame", {
		Size = UDim2.fromOffset(size, size), Position = pos, AnchorPoint = anchor or Vector2.new(0, 0),
		BackgroundTransparency = 1,
	}, parent)
	if LogoAsset then
		local img = new("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
			Image = LogoAsset, ScaleType = Enum.ScaleType.Fit,
		}, h)
		corner(img, math.max(4, math.floor(size * 0.12)))
		return h
	end
	new("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(2, 3),
		Text = "KR", Font = Enum.Font.GothamBlack, TextScaled = true,
		TextColor3 = Color3.fromRGB(60, 60, 66), Rotation = -4,
	}, h)
	local main = new("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		Text = "KR", Font = Enum.Font.GothamBlack, TextScaled = true,
		TextColor3 = Color3.new(1, 1, 1), Rotation = -4,
	}, h)
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(190, 190, 198)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 118)),
		}),
	}, main)
	new("UIStroke", { Color = Color3.fromRGB(10, 10, 10), Thickness = 2 }, main)
	return h
end

---------------------------------------------------------------------
-- SYSTÈMES BRILLANTS & EXPIRATION (V1.8.7 BLANC BRILLANT SANS SPARKLES)
---------------------------------------------------------------------
local function isLifetimeVal(e)
	if e == nil or e == "Lifetime" then return true end
	if type(e) == "number" and e > 4102444800 then return true end
	return false
end

local function expiresText(e)
	if isLifetimeVal(e) then return S("lifetime") end
	if type(e) == "number" then
		return os.date("%d/%m/%Y", e)
	end
	return tostring(e)
end

local function rankTheme(rk)
	if rk == "free" then
		return { c0 = Color3.fromRGB(35, 145, 255), c1 = Color3.fromRGB(150, 225, 255), spark = Color3.fromRGB(190, 240, 255) }
	elseif rk == "standard" then
		return { c0 = Color3.fromRGB(35, 215, 95), c1 = Color3.fromRGB(165, 255, 195), spark = Color3.fromRGB(200, 255, 220) }
	end
	return { c0 = Color3.fromRGB(245, 195, 40), c1 = Color3.fromRGB(255, 250, 145), spark = Color3.fromRGB(255, 245, 170) }
end

local function startSparkles(parent, count, color, isOn)
	for _ = 1, count do
		local s = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(9, 9), BackgroundTransparency = 1, Visible = false, ZIndex = 6 }, parent)
		new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(9, 1.5), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 6 }, s)
		new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(1.5, 9), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 6 }, s)
		local sc = new("UIScale", { Scale = 0 }, s)
		task.spawn(function()
			task.wait(math.random() * 1.5)
			while alive(s) do
				if isOn() then
					s.Position = UDim2.fromScale(math.random(5, 95) / 100, math.random(10, 90) / 100)
					s.Rotation = math.random(0, 45)
					s.Visible = true
					tween(sc, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
					task.wait(0.26)
					tween(sc, 0.3, { Scale = 0 })
					task.wait(0.32)
					s.Visible = false
				end
				task.wait(0.3 + math.random() * 0.9)
			end
		end)
	end
end

local function applyRankShine(lbl, theme)
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.AutomaticSize = Enum.AutomaticSize.X
	lbl.Size = UDim2.fromOffset(0, lbl.Size.Y.Offset)
	local W = Color3.new(1, 1, 1)
	local grad = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, theme.c0),
			ColorSequenceKeypoint.new(0.3, theme.c1),
			ColorSequenceKeypoint.new(0.45, W),
			ColorSequenceKeypoint.new(0.55, W),
			ColorSequenceKeypoint.new(0.7, theme.c1),
			ColorSequenceKeypoint.new(1, theme.c0),
		}),
		Offset = Vector2.new(-1, 0),
	}, lbl)
	local st = new("UIStroke", { Color = theme.c0:Lerp(Color3.new(0, 0, 0), 0.6), Thickness = 1.2, Transparency = 1 }, lbl)
	task.spawn(function()
		repeat task.wait(0.1) until not alive(lbl) or lbl.TextTransparency < 0.9
		while alive(lbl) do
			grad.Offset = Vector2.new(-1, 0)
			tween(grad, 1.2, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(st, 0.6, { Transparency = 0.05 }, Enum.EasingStyle.Sine)
			task.wait(0.6)
			tween(st, 0.6, { Transparency = 0.35 }, Enum.EasingStyle.Sine)
			task.wait(1.6)
		end
	end)
	startSparkles(lbl, 3, theme.spark, function() return lbl.TextTransparency < 0.5 end)
end

local function makeExpiry(parent, pos, width, h, textSize)
	local root = new("Frame", { Position = pos, Size = UDim2.fromOffset(width, h), BackgroundTransparency = 1 }, parent)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }, root)
	local pre = new("TextLabel", { LayoutOrder = 1, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h), Text = "", Font = Enum.Font.Gotham, TextSize = textSize, TextColor3 = C.muted }, root)
	local val = new("TextLabel", { LayoutOrder = 2, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h), Text = "", Font = Enum.Font.GothamBlack, TextSize = textSize, TextColor3 = Color3.new(1, 1, 1) }, root)
	local grad = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 240)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(250, 250, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(250, 250, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 235, 240)),
		}),
		Offset = Vector2.new(-1, 0),
	}, val)
	local st = new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.4 }, val)
	local self = { root = root }
	function self.set(prefixText, e)
		pre.Text = prefixText or ""
		val.Text = expiresText(e)
	end
	task.spawn(function()
		while alive(root) do
			grad.Offset = Vector2.new(-1, 0)
			tween(grad, 1.3, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(st, 0.65, { Transparency = 0.3 }, Enum.EasingStyle.Sine)
			task.wait(0.65)
			tween(st, 0.65, { Transparency = 0.6 }, Enum.EasingStyle.Sine)
			task.wait(2.2)
		end
	end)
	return self
end

local function maskKey(k)
	k = tostring(k or "")
	local n = utf8.len(k) or #k
	if n == 0 then return "—" end
	if n <= 8 then return string.rep("•", n) end
	return string.sub(k, 1, 4) .. "••••" .. string.sub(k, -4)
end

local function deviceId()
	local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
	if ok and type(id) == "string" and id ~= "" then
		return id
	end
	return "N/A"
end

local function getGameName()
	local ok, n = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId).Name end)
	return (ok and n) or "Unknown"
end

local function isGameSupported()
	local low = string.lower(getGameName())
	for _, g in ipairs(Config.SupportedGames) do
		if string.find(low, string.lower(g), 1, true) then return true end
	end
	for _, id in ipairs(Config.SupportedPlaceIds) do
		if id == game.PlaceId then return true end
	end
	return false
end

local function httpPost(data)
	if not globalRequest then return end
	pcall(function() globalRequest(data) end)
end

local function openDiscord()
	if setclipboard then pcall(setclipboard, Config.DiscordLink) end
	httpPost({
		Url = "http://127.0.0.1:6463/rpc?v=1",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
		Body = HttpService:JSONEncode({
			cmd = "INVITE_BROWSER",
			args = { code = Config.DiscordCode },
			nonce = HttpService:GenerateGUID(false),
		}),
	})
end

---------------------------------------------------------------------
-- REQUÊTE HTTP ROBUSTE
---------------------------------------------------------------------
local function httpJson(path, payload, tries, delaySec)
	tries = tries or 6
	delaySec = delaySec or 5
	local lastCode = 0
	for attempt = 1, tries do
		local ok, res = pcall(globalRequest, {
			Url = Config.ApiBaseUrl .. path,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Accept"] = "application/json",
			},
			Body = HttpService:JSONEncode(payload),
		})
		if ok and type(res) == "table" then
			local body = res.Body or res.body
			local code = tonumber(res.StatusCode or res.status_code or res.Status or res.status) or 0
			lastCode = code
			if type(body) == "string" and body ~= "" then
				local dok, dec = pcall(function() return HttpService:JSONDecode(body) end)
				if dok and type(dec) == "table" then
					return dec, code
				end
			end
			if code == 429 then
				return { error = "rate" }, code
			end
		end
		if attempt < tries then task.wait(delaySec) end
	end
	return nil, lastCode
end

---------------------------------------------------------------------
-- RESET HWID
---------------------------------------------------------------------
local function resetHwid(username)
	if not globalRequest or not username or username == "" then return false end
	local data = httpJson("/api/hwid-reset", {
		username = username,
		password = Session.password or "",
		hwid = deviceId(),
	}, 3, 4)
	if type(data) == "table" then
		return data.ok == true or data.success == true
	end
	return false
end

---------------------------------------------------------------------
-- GUI ROOT & FENÊTRE DE CONNEXION
---------------------------------------------------------------------
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("KryptonLauncher")
if old then old:Destroy() end

local gui = new("ScreenGui", {
	Name = "KryptonLauncher", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100,
}, pg)
setupGuiProtection(gui)

local window = new("Frame", {
	Size = UDim2.fromOffset(744, 466), AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
	BorderSizePixel = 0, ClipsDescendants = true,
}, gui)
corner(window, 14)
stroke(window, C.stroke, 1, 0.3)

local scale = new("UIScale", {}, window)
local function updateScale()
	local v = gui.AbsoluteSize
	scale.Scale = math.clamp(math.min(v.X / 800, v.Y / 600), 0.4, 1)
end
updateScale()
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

---------------------------------------------------------------------
-- SYSTÈME ESP UNIVERSEL & SQUELETTE AMÉLIORÉ V1.8.7
---------------------------------------------------------------------
pcall(function()
	if getgenv then
		local g = getgenv()
		if g.KryptonESPConn then
			g.KryptonESPConn:Disconnect()
			g.KryptonESPConn = nil
		end
	end
end)
do
	local oldEsp = pg:FindFirstChild("KryptonESP")
	if oldEsp then oldEsp:Destroy() end
end

local espGui = new("ScreenGui", {
	Name = "KryptonESP", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 90,
}, pg)
setupGuiProtection(espGui)

local espCount = new("TextLabel", {
	AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.fromOffset(180, 20),
	BackgroundTransparency = 1, Text = "", TextSize = 13, TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold, TextStrokeTransparency = 0.4, Visible = false,
}, espGui)

local espObjs = {}
local ESP_WHITE = Color3.new(1, 1, 1)
local ESP_SKEL = Color3.fromRGB(150, 215, 255)

local function mkFrame(parent, col)
	return new("Frame", { BackgroundColor3 = col, BorderSizePixel = 0, Visible = false }, parent)
end
local function mkLine(parent, col)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false }, parent)
	cornerS(f, 0.5)
	stroke(f, Color3.fromRGB(10, 10, 15), 1.2, 0.3)
	return f
end
local function mkText(parent, size, col, font)
	return new("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.fromOffset(220, 14), BackgroundTransparency = 1,
		Text = "", TextSize = size, TextColor3 = col, Font = font, TextStrokeTransparency = 0.4, Visible = false,
	}, parent)
end
local function setLine(f, x1, y1, x2, y2, th)
	local dx, dy = x2 - x1, y2 - y1
	f.Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
	f.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), th)
	f.Rotation = math.deg(math.atan2(dy, dx))
	f.Visible = true
end

local function removeEsp(plr)
	local d = espObjs[plr]
	if d then
		pcall(function() d.folder:Destroy() end)
		espObjs[plr] = nil
	end
end

local function hideEsp(d)
	for _, o in ipairs(d.all) do o.Visible = false end
	for _, jf in pairs(d.joints) do jf.Visible = false end
	d.smoothedJoints = {}
end

local function createEsp(plr)
	local folder = new("Folder", { Name = plr.Name }, espGui)
	local d = { folder = folder, all = {}, bones = {}, boneShadows = {}, joints = {}, smoothedJoints = {} }
	local function add(o)
		d.all[#d.all + 1] = o
		return o
	end
	d.box = add(new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false }, folder))
	stroke(d.box, ESP_WHITE, 1.5)
	d.snap = add(mkLine(folder, ESP_WHITE))
	d.name = add(mkText(folder, 13, ESP_WHITE, Enum.Font.GothamBold))
	d.dist = add(mkText(folder, 11, Color3.fromRGB(200, 205, 215), Enum.Font.GothamMedium))
	d.dist.ZIndex = 3
	local distBg = add(new("Frame", { BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Visible = false }, folder))
	corner(distBg, 3)
	d.distBg = distBg
	d.weapon = add(mkText(folder, 11, Color3.fromRGB(235, 215, 160), Enum.Font.GothamMedium))
	d.weapon.ZIndex = 3
	local weapBg = add(new("Frame", { BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Visible = false }, folder))
	corner(weapBg, 3)
	d.weapBg = weapBg
	d.hbBg = add(mkFrame(folder, Color3.new(0, 0, 0)))
	d.hbBg.BackgroundTransparency = 0.4
	d.hb = add(mkFrame(folder, Color3.fromRGB(0, 255, 0)))
	d.hNum = add(new("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(110, 231, 140), TextXAlignment = Enum.TextXAlignment.Right, TextStrokeTransparency = 0.5, Visible = false }, folder))
	d.abBg = add(mkFrame(folder, Color3.new(0, 0, 0)))
	d.abBg.BackgroundTransparency = 0.4
	d.ab = add(mkFrame(folder, Color3.fromRGB(90, 160, 255)))
	d.aNum = add(new("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(130, 190, 255), TextXAlignment = Enum.TextXAlignment.Right, TextStrokeTransparency = 0.5, Visible = false }, folder))
	for i = 1, 24 do
		local b, sh = mkBone(folder, ESP_SKEL)
		d.bones[i] = add(b)
		d.boneShadows[i] = add(sh)
	end
	for _, jn in ipairs(JOINT_NAMES) do
		local jsz = (jn == "Head") and 7 or 4
		d.joints[jn] = add(mkJoint(folder, ESP_SKEL, jsz))
	end
	espObjs[plr] = d
	return d
end

local ARMOR_KEYS = { "Armor", "Armour", "Shield", "Kevlar", "Vest" }
local function readAttr(inst)
	if not inst then return nil end
	for _, k in ipairs(ARMOR_KEYS) do
		local a = inst:GetAttribute(k)
		if type(a) == "number" then return a end
	end
	return nil
end
local function getArmor(plr, char, hum)
	local v = readAttr(char) or readAttr(hum) or readAttr(plr)
	if not v then
		for _, k in ipairs(ARMOR_KEYS) do
			local o = char:FindFirstChild(k) or hum:FindFirstChild(k)
			if o and o:IsA("ValueBase") and type(o.Value) == "number" then
				v = o.Value
				break
			end
		end
	end
	if not v then return nil end
	local mx = char:GetAttribute("MaxArmor") or hum:GetAttribute("MaxArmor") or 100
	if type(mx) ~= "number" or mx <= 0 then mx = 100 end
	return math.clamp(v, 0, mx), mx
end

local function getWeapon(char)
	local t = char:FindFirstChildOfClass("Tool")
	return t and t.Name or nil
end

local function updatePlayer(plr, V, cam, vs, dt)
	local char = plr.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local d = espObjs[plr]
	if not (V.enable and root and hum and hum.Health > 0) then
		if d then removeEsp(plr) end
		return
	end
	local cf, size = char:GetBoundingBox()
	local topWorld = (cf.Position + Vector3.new(0, size.Y / 2 + 0.15, 0))
	local botWorld = (cf.Position - Vector3.new(0, size.Y / 2 + 0.1, 0))
	local top = cam:WorldToViewportPoint(topWorld)
	local bot = cam:WorldToViewportPoint(botWorld)
	local h = math.clamp(bot.Y - top.Y, 8, 3000)
	local w = h * 0.6
	local rootPos, onScreen = cam:WorldToViewportPoint(root.Position)
	if not (onScreen and rootPos.Z > 0) then
		if d then hideEsp(d) end
		return
	end
	if not d then d = createEsp(plr) end
	local cx = rootPos.X
	local x0 = math.floor(cx - w / 2 + 0.5)
	local y0 = math.floor(top.Y + 0.5)
	local x1, y1 = x0 + w, y0 + h
	local dist = (cam.CFrame.Position - root.Position).Magnitude
	if V.boxes then
		d.box.Position = UDim2.fromOffset(x0, y0)
		d.box.Size = UDim2.fromOffset(w, h)
		d.box.Visible = true
	else
		d.box.Visible = false
	end
	if V.snaplines then
		if V.snapPos == "Top" then
			setLine(d.snap, vs.X / 2, 0, cx, y0, 1.2)
		else
			setLine(d.snap, vs.X / 2, vs.Y, cx, y1, 1.2)
		end
	else
		d.snap.Visible = false
	end
	if V.names then
		d.name.Text = plr.DisplayName
		d.name.Position = UDim2.fromOffset(cx, y0 - 17)
		d.name.Visible = true
	else
		d.name.Visible = false
	end
	local av, amax = getArmor(plr, char, hum)
	local showArmor = V.armor and av ~= nil
	local showHealth = V.health
	local numX = showArmor and (x0 - 16) or (x0 - 10)
	local numYh, numYa
	if showHealth then
		local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
		d.hbBg.Position = UDim2.fromOffset(x0 - 7, y0 - 1)
		d.hbBg.Size = UDim2.fromOffset(4, h + 2)
		d.hbBg.Visible = true
		d.hb.Position = UDim2.fromOffset(x0 - 6, y0 + h * (1 - pct))
		d.hb.Size = UDim2.fromOffset(2, h * pct)
		d.hb.BackgroundColor3 = Color3.fromRGB(255 * (1 - pct), 255 * pct, 0)
		d.hb.Visible = true
		numYh = math.clamp(y0 + h * (1 - pct), y0, y1 - 4)
	else
		d.hbBg.Visible = false
		d.hb.Visible = false
		d.hNum.Visible = false
	end
	if showArmor then
		local apct = math.clamp(av / amax, 0, 1)
		local abX = showHealth and (x0 - 13) or (x0 - 7)
		d.abBg.Position = UDim2.fromOffset(abX, y0 - 1)
		d.abBg.Size = UDim2.fromOffset(4, h + 2)
		d.abBg.Visible = true
		d.ab.Position = UDim2.fromOffset(abX + 1, y0 + h * (1 - apct))
		d.ab.Size = UDim2.fromOffset(2, h * apct)
		d.ab.Visible = true
		numYa = math.clamp(y0 + h * (1 - apct), y0, y1 - 4)
	else
		d.abBg.Visible = false
		d.ab.Visible = false
		d.aNum.Visible = false
	end
	if numYh and numYa and math.abs(numYa - numYh) < 11 then
		numYa = math.clamp(numYh + 11, y0, y1 + 8)
	end
	if numYh then
		d.hNum.Text = tostring(math.floor(hum.Health + 0.5))
		d.hNum.Position = UDim2.fromOffset(numX, numYh)
		d.hNum.Visible = true
	end
	if numYa then
		d.aNum.Text = tostring(math.floor(av + 0.5))
		d.aNum.Position = UDim2.fromOffset(numX, numYa)
		d.aNum.Visible = true
	end
	local by = y1 + 6
	if V.distance then
		d.dist.Text = math.floor(dist) .. "m"
		d.dist.Position = UDim2.fromOffset(cx, by)
		d.dist.Visible = true
		d.distBg.Position = UDim2.fromOffset(cx - 22, by)
		d.distBg.Size = UDim2.fromOffset(44, 14)
		d.distBg.Visible = true
		by += 16
	else
		d.dist.Visible = false
		d.distBg.Visible = false
	end
	local wname = V.weapon and getWeapon(char) or nil
	if wname then
		d.weapon.Text = wname
		d.weapon.Position = UDim2.fromOffset(cx, by)
		d.weapon.Visible = true
		d.weapBg.Position = UDim2.fromOffset(cx - 35, by)
		d.weapBg.Size = UDim2.fromOffset(70, 14)
		d.weapBg.Visible = true
	else
		d.weapon.Visible = false
		d.weapBg.Visible = false
	end
	if V.skeleton then
		local points = getSkeletonPoints(char)
		local skelTh = math.clamp(2.2 - dist / 150, 1.4, 2.2)
		local alpha = 1 - math.exp(-dt * 22)
		local shown = {}
		for name, pos in pairs(points) do
			local wp, ok = cam:WorldToViewportPoint(pos)
			if ok and wp.Z > 0 then
				local targetV2 = Vector2.new(wp.X, wp.Y)
				local currentV2 = d.smoothedJoints[name]
				if not currentV2 then
					currentV2 = targetV2
				else
					currentV2 = currentV2:Lerp(targetV2, alpha)
				end
				d.smoothedJoints[name] = currentV2
				shown[name] = { pos = currentV2, visible = true }
			else
				d.smoothedJoints[name] = nil
			end
		end
		for i = 1, #d.bones do
			local ln = d.bones[i]
			local sh = d.boneShadows[i]
			local boneData = SKELETON_BONES[i]
			if boneData then
				local j1 = shown[boneData[1]]
				local j2 = shown[boneData[2]]
				if j1 and j2 then
					setBoneLine(ln, sh, j1.pos.X, j1.pos.Y, j2.pos.X, j2.pos.Y, skelTh)
				else
					ln.Visible = false
					if sh then sh.Visible = false end
				end
			else
				ln.Visible = false
				if sh then sh.Visible = false end
			end
		end
		local jsz = math.clamp(math.floor(5 - dist / 80), 3, 5)
		for name, jf in pairs(d.joints) do
			local jInfo = shown[name]
			if jInfo then
				jf.Position = UDim2.fromOffset(jInfo.pos.X, jInfo.pos.Y)
				local sz = (name == "Head") and (jsz + 3) or jsz
				jf.Size = UDim2.fromOffset(sz, sz)
				jf.Visible = true
			else
				jf.Visible = false
			end
		end
	else
		d.smoothedJoints = {}
		for i = 1, #d.bones do
			d.bones[i].Visible = false
			if d.boneShadows[i] then d.boneShadows[i].Visible = false end
		end
		for _, jf in pairs(d.joints) do jf.Visible = false end
	end
end

Players.PlayerRemoving:Connect(removeEsp)

local lastRenderTick = os.clock()
local espConn = RunService.RenderStepped:Connect(function()
	if not Authed then return end
	local now = os.clock()
	local dt = now - lastRenderTick
	lastRenderTick = now
	dt = math.clamp(dt, 0.001, 0.1)

	local V = Settings.Visuals
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vs = cam.ViewportSize
	if V.enable and V.count then
		espCount.Text = S("playersLbl") .. ": " .. #Players:GetPlayers()
		espCount.Visible = true
	else
		espCount.Visible = false
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			pcall(updatePlayer, plr, V, cam, vs, dt)
		end
	end
end)
pcall(function() if getgenv then getgenv().KryptonESPConn = espConn end end)

---------------------------------------------------------------------
-- PANNEAU DROIT (Radar & Logo KR)
---------------------------------------------------------------------
local right = new("Frame", {
	Position = UDim2.fromOffset(340, 0), Size = UDim2.fromOffset(404, 466),
	BackgroundColor3 = Color3.fromRGB(26, 26, 28), BorderSizePixel = 0,
}, window)
corner(right, 14)
new("UIGradient", {
	Rotation = 0,
	Color = ColorSequence.new(C.bg, Color3.fromRGB(28, 28, 30)),
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.3), NumberSequenceKeypoint.new(1, 0),
	}),
}, right)

makeParticles(right, 404, 466, 18)

local CENTER = Vector2.new(553 - 340, 212)

local function circle(radius, transp)
	local f = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
		Size = UDim2.fromOffset(radius * 2, radius * 2), BackgroundTransparency = 1,
	}, right)
	corner(f, radius)
	stroke(f, Color3.fromRGB(80, 80, 86), 1, transp)
	return f
end
local c1 = circle(138, 0.5)
local c2 = circle(85, 0.65)

task.spawn(function()
	while alive(right) do
		tween(c1, 2, { Size = UDim2.fromOffset(290, 290) })
		tween(c2, 2, { Size = UDim2.fromOffset(180, 180) })
		task.wait(2)
		tween(c1, 2, { Size = UDim2.fromOffset(276, 276) })
		tween(c2, 2, { Size = UDim2.fromOffset(170, 170) })
		task.wait(2)
	end
end)

local sweep = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
	Size = UDim2.fromOffset(276, 276), BackgroundTransparency = 1,
}, right)
corner(sweep, 138)
stroke(sweep, Color3.new(1, 1, 1), 2, 0)
local sweepGrad = new("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.55, 1),
		NumberSequenceKeypoint.new(0.8, 0.45), NumberSequenceKeypoint.new(1, 0.05),
	}),
}, sweep:FindFirstChildOfClass("UIStroke"))

task.spawn(function()
	while alive(right) do
		local r = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
			Size = UDim2.fromOffset(80, 80), BackgroundTransparency = 1,
		}, right)
		cornerS(r, 0.5)
		local s = stroke(r, Color3.fromRGB(200, 200, 210), 1.5, 0.35)
		tween(r, 2.6, { Size = UDim2.fromOffset(276, 276) })
		tween(s, 2.6, { Transparency = 1 })
		task.wait(1.4)
	end
end)

local dot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = Color3.fromRGB(235, 235, 240), BorderSizePixel = 0,
}, right)
cornerS(dot, 0.5)
new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.7, Thickness = 3 }, dot)

local dot2 = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(4, 4),
	BackgroundColor3 = Color3.fromRGB(170, 170, 180), BorderSizePixel = 0,
}, right)
cornerS(dot2, 0.5)
new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.8, Thickness = 2 }, dot2)

local angle = math.rad(100)
local sweepConn
sweepConn = RunService.RenderStepped:Connect(function(dt)
	if not alive(right) then sweepConn:Disconnect() return end
	angle += dt * 0.7
	dot.Position = UDim2.fromOffset(CENTER.X + math.cos(angle) * 138, CENTER.Y + math.sin(angle) * 138)
	dot2.Position = UDim2.fromOffset(CENTER.X + math.cos(-angle * 1.6 + 2) * 85, CENTER.Y + math.sin(-angle * 1.6 + 2) * 85)
	sweepGrad.Rotation = (sweepGrad.Rotation + dt * 80) % 360
end)

local glow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
	Size = UDim2.fromOffset(180, 180), BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0.94, BorderSizePixel = 0,
}, right)
cornerS(glow, 0.5)
task.spawn(function()
	while alive(right) do
		tween(glow, 1.6, { BackgroundTransparency = 0.88, Size = UDim2.fromOffset(205, 205) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1.6)
		tween(glow, 1.6, { BackgroundTransparency = 0.96, Size = UDim2.fromOffset(170, 170) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1.6)
	end
end)

local bigLogo = makeLogo(right, 130, UDim2.fromOffset(CENTER.X, CENTER.Y), Vector2.new(0.5, 0.5))

task.spawn(function()
	local t = 0
	while alive(right) do
		t += task.wait()
		bigLogo.Position = UDim2.fromOffset(CENTER.X, CENTER.Y + math.sin(t * 2) * 5)
		bigLogo.Rotation = math.sin(t * 1.5) * 2
		glow.Position = bigLogo.Position
	end
end)

label(right, Config.Name, 16, UDim2.fromOffset(CENTER.X - 100, 421), UDim2.fromOffset(200, 22), C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
label(right, Config.Subtitle, 10, UDim2.fromOffset(CENTER.X - 100, 444), UDim2.fromOffset(200, 14), C.muted, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)

---------------------------------------------------------------------
-- BARRE DU HAUT & ELEMENTS LOGIN
---------------------------------------------------------------------
local topbar = new("Frame", { Size = UDim2.fromOffset(744, 60), BackgroundTransparency = 1 }, window)
makeDraggable(window, topbar)

local closeBtn = new("TextButton", {
	Position = UDim2.fromOffset(704, 16), Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1,
	Text = "", AutoButtonColor = false, ZIndex = 5,
}, window)
local closeX = Icons.cross(closeBtn, 16, 16, 11, C.muted)
local function tintX(col)
	for _, f in ipairs(closeX:GetChildren()) do
		if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = col }) end
	end
end
closeBtn.MouseEnter:Connect(function() tintX(C.text); tween(closeX, 0.3, { Rotation = 90 }, Enum.EasingStyle.Back) end)
closeBtn.MouseLeave:Connect(function() tintX(C.muted); tween(closeX, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back) end)
closeBtn.MouseButton1Click:Connect(function()
	tween(window, 0.3, { Size = UDim2.fromOffset(744, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.wait(0.32)
	gui:Destroy()
end)

makeLogo(window, 32, UDim2.fromOffset(24, 20))

local discordBtn = new("TextButton", {
	Position = UDim2.fromOffset(170, 22), Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = C.discord, Text = "", AutoButtonColor = false, ZIndex = 3, ClipsDescendants = true,
}, window)
corner(discordBtn, 8)

if DiscordAsset then
	local dImg = new("ImageLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		Image = DiscordAsset, ScaleType = Enum.ScaleType.Crop, ZIndex = 4,
	}, discordBtn)
	corner(dImg, 8)
end

discordBtn.MouseEnter:Connect(function()
	tween(discordBtn, 0.2, { BackgroundColor3 = Color3.fromRGB(112, 124, 255), Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(168, 20), Rotation = 6 }, Enum.EasingStyle.Back)
end)
discordBtn.MouseLeave:Connect(function()
	tween(discordBtn, 0.2, { BackgroundColor3 = C.discord, Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(170, 22), Rotation = 0 }, Enum.EasingStyle.Back)
end)
Icons.globe(window, 212, 27, C.muted).ZIndex = 3

local langBtns, langStrokes = {}, {}
local function langButton(code, x)
	local b = new("TextButton", {
		Position = UDim2.fromOffset(x, 23), Size = UDim2.fromOffset(32, 26), BackgroundColor3 = C.field,
		Text = code, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.muted,
		AutoButtonColor = false, ZIndex = 3,
	}, window)
	corner(b, 6)
	langStrokes[code] = stroke(b, C.stroke, 1)
	langBtns[code] = b
	b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 34) }) end)
	b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = C.field }) end)
end
langButton("FR", 238)
langButton("EN", 276)

local isSignup = false

local Y_USER, Y_PASS = 104, 156
local Y_REMEMBER, Y_STATUS, Y_SUBMIT, Y_GETKEY = 206, 238, 258, 308

local leftContainer = new("Frame", {
	Position = UDim2.fromOffset(24, 75), Size = UDim2.fromOffset(300, 380),
	BackgroundTransparency = 1,
}, window)

local title = label(leftContainer, "", 22, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 30), C.text, Enum.Font.GothamBlack)
local subtitle = label(leftContainer, "", 11, UDim2.fromOffset(0, 32), UDim2.fromOffset(300, 16), C.muted, Enum.Font.Gotham)

local tabContainer = new("Frame", {
	Position = UDim2.fromOffset(0, 56), Size = UDim2.fromOffset(300, 36), BackgroundColor3 = C.tabBg,
}, leftContainer)
corner(tabContainer, 8)
stroke(tabContainer, C.stroke, 1)

local tabPill = new("Frame", {
	Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(144, 30), BackgroundColor3 = C.tabSel,
	BorderSizePixel = 0, ZIndex = 1,
}, tabContainer)
corner(tabPill, 6)

local function makeTab(x, active)
	local b = new("TextButton", {
		Position = UDim2.fromOffset(x, 3), Size = UDim2.fromOffset(144, 30), BackgroundTransparency = 1,
		Text = "", Font = Enum.Font.GothamBold, TextSize = 12,
		TextColor3 = active and C.text or C.muted, AutoButtonColor = false, ZIndex = 2,
	}, tabContainer)
	corner(b, 6)
	return b
end

local tabSignin = makeTab(3, true)
local tabSignup = makeTab(153, false)

local function field(y, iconFn)
	local f = new("Frame", {
		Position = UDim2.fromOffset(0, y), Size = UDim2.fromOffset(300, 40), BackgroundColor3 = C.field, BorderSizePixel = 0,
	}, leftContainer)
	corner(f, 8)
	local st = stroke(f, C.stroke, 1)
	iconFn(f, 12, 11, C.muted)
	local box = new("TextBox", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 0), Size = UDim2.fromOffset(250, 40),
		Text = "", PlaceholderText = "", PlaceholderColor3 = C.muted, TextColor3 = C.text,
		Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	}, f)
	box.Focused:Connect(function()
		tween(st, 0.15, { Color = Color3.fromRGB(110, 110, 120), Thickness = 1.6 })
		tween(f, 0.15, { BackgroundColor3 = Color3.fromRGB(23, 23, 26) })
	end)
	box.FocusLost:Connect(function()
		tween(st, 0.15, { Color = C.stroke, Thickness = 1 })
		tween(f, 0.15, { BackgroundColor3 = C.field })
	end)
	return f, box, st
end

local maskUpdaters = {}
local function secretField(y, iconFn, phFn)
	local f, box, st = field(y, iconFn)
	box.Size = UDim2.fromOffset(214, 40)
	local hidden = true
	local overlay = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 0), Size = UDim2.fromOffset(214, 40),
		Text = "", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2,
	}, f)
	local function updateMask()
		if hidden then
			box.TextTransparency = 1
			box.PlaceholderText = ""
			local n = utf8.len(box.Text) or #box.Text
			if n == 0 then
				overlay.Text = phFn()
				overlay.TextColor3 = C.muted
			else
				overlay.Text = string.rep("•", n)
				overlay.TextColor3 = C.text
			end
		else
			box.TextTransparency = 0
			box.PlaceholderText = phFn()
			overlay.Text = ""
		end
	end
	box:GetPropertyChangedSignal("Text"):Connect(updateMask)
	local eyeBtn = new("TextButton", {
		Position = UDim2.fromOffset(262, 5), Size = UDim2.fromOffset(30, 30), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, ZIndex = 4,
	}, f)
	local eyeIcon
	local function drawEye()
		if eyeIcon then eyeIcon:Destroy() end
		eyeIcon = Icons.eye(eyeBtn, 6, 6, C.muted, hidden)
		eyeIcon.ZIndex = 4
	end
	drawEye()
	eyeBtn.MouseEnter:Connect(function() tintIcon(eyeIcon, C.text) end)
	eyeBtn.MouseLeave:Connect(function() tintIcon(eyeIcon, C.muted) end)
	eyeBtn.MouseButton1Click:Connect(function()
		hidden = not hidden
		drawEye()
		updateMask()
	end)
	maskUpdaters[#maskUpdaters + 1] = updateMask
	updateMask()
	return f, box, st
end

local userField, userBox, userStroke = field(Y_USER, Icons.user)
local passField, passBox, passStroke = secretField(Y_PASS, Icons.lock, function() return S("passPh") end)

local remember = true
local rememberBtn = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_REMEMBER), Size = UDim2.fromOffset(300, 24), BackgroundTransparency = 1,
	Text = "", AutoButtonColor = false, ZIndex = 3,
}, leftContainer)
local rBox = new("Frame", {
	AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(6, 12), Size = UDim2.fromOffset(18, 18),
	BackgroundColor3 = C.text, BorderSizePixel = 0,
}, rememberBtn)
corner(rBox, 5)
local rStroke = stroke(rBox, C.text, 1)
local rMark = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
}, rBox)
Icons.check(rMark, Color3.new(0, 0, 0))
local rMarkScale = new("UIScale", { Scale = 1 }, rMark)
local rememberLbl = label(rememberBtn, "", 12, UDim2.fromOffset(34, 0), UDim2.fromOffset(250, 24), Color3.fromRGB(200, 200, 205), Enum.Font.Gotham)

local function setRemember(on, instant)
	remember = on
	local bg = on and C.text or C.field
	local sk = on and C.text or C.stroke
	if instant then
		rBox.BackgroundColor3 = bg
		rStroke.Color = sk
		rMarkScale.Scale = on and 1 or 0
	else
		tween(rBox, 0.2, { BackgroundColor3 = bg })
		tween(rStroke, 0.2, { Color = sk })
		tween(rMarkScale, 0.25, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
	end
end
setRemember(true, true)
rememberBtn.MouseButton1Click:Connect(function() setRemember(not remember) end)
rememberBtn.MouseEnter:Connect(function() tween(rememberLbl, 0.15, { TextColor3 = C.text }) end)
rememberBtn.MouseLeave:Connect(function() tween(rememberLbl, 0.15, { TextColor3 = Color3.fromRGB(200, 200, 205) }) end)

local status = label(leftContainer, "", 11, UDim2.fromOffset(0, Y_STATUS), UDim2.fromOffset(300, 16), C.err, Enum.Font.GothamMedium)

local submit = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_SUBMIT), Size = UDim2.fromOffset(300, 42), BackgroundColor3 = Color3.fromRGB(250, 250, 250),
	Text = "", AutoButtonColor = false, ClipsDescendants = true,
}, leftContainer)
corner(submit, 10)
local submitText = new("TextLabel", {
	BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = Enum.Font.GothamBold, TextSize = 13,
	TextColor3 = Color3.new(0, 0, 0), Text = "",
}, submit)

local shine = new("Frame", {
	Size = UDim2.fromOffset(40, 70), Position = UDim2.fromOffset(-60, -14), Rotation = 20,
	BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.55, BorderSizePixel = 0,
}, submit)
new("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
	}),
}, shine)
task.spawn(function()
	while alive(submit) do
		shine.Position = UDim2.fromOffset(-60, -14)
		tween(shine, 0.9, { Position = UDim2.fromOffset(340, -14) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(4)
	end
end)

submit.MouseEnter:Connect(function() tween(submit, 0.15, { BackgroundColor3 = Color3.fromRGB(225, 225, 228) }) end)
submit.MouseLeave:Connect(function()
	tween(submit, 0.15, { BackgroundColor3 = Color3.fromRGB(250, 250, 250), Size = UDim2.fromOffset(300, 42), Position = UDim2.fromOffset(0, Y_SUBMIT) })
end)
submit.MouseButton1Down:Connect(function()
	tween(submit, 0.1, { Size = UDim2.fromOffset(292, 38), Position = UDim2.fromOffset(4, Y_SUBMIT + 2) })
end)
submit.MouseButton1Up:Connect(function()
	tween(submit, 0.2, { Size = UDim2.fromOffset(300, 42), Position = UDim2.fromOffset(0, Y_SUBMIT) }, Enum.EasingStyle.Back)
end)

local getKeyBtn = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_GETKEY), Size = UDim2.fromOffset(300, 36), BackgroundColor3 = C.discord,
	Text = "", AutoButtonColor = false, Visible = false, ClipsDescendants = true,
}, leftContainer)
corner(getKeyBtn, 8)

local getKeyText = new("TextLabel", {
	BackgroundTransparency = 1, Position = UDim2.fromOffset(36, 0), Size = UDim2.fromOffset(254, 36),
	Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.text, Text = "",
	TextXAlignment = Enum.TextXAlignment.Left,
}, getKeyBtn)

if DiscordAsset then
	local btnDImg = new("ImageLabel", {
		Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1, Image = DiscordAsset, ScaleType = Enum.ScaleType.Crop,
	}, getKeyBtn)
	corner(btnDImg, 4)
end

getKeyBtn.MouseEnter:Connect(function() tween(getKeyBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(105, 116, 255) }) end)
getKeyBtn.MouseLeave:Connect(function() tween(getKeyBtn, 0.15, { BackgroundColor3 = C.discord }) end)

local gameState = nil
local badge = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(CENTER.X, 388),
	Size = UDim2.fromOffset(190, 28), BackgroundColor3 = C.panel, BorderSizePixel = 0,
}, right)
corner(badge, 14)
local badgeStroke = stroke(badge, C.stroke, 1)
local badgeDot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 14),
	Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.muted, BorderSizePixel = 0,
}, badge)
new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, badgeDot)
local badgeText = label(badge, "", 11, UDim2.fromOffset(34, 0), UDim2.fromOffset(150, 28), C.text, Enum.Font.GothamMedium)

task.spawn(function()
	while alive(badge) do
		local r = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 14),
			Size = UDim2.fromOffset(8, 8), BackgroundTransparency = 1,
		}, badge)
		new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, r)
		local s = stroke(r, badgeDot.BackgroundColor3, 1.5, 0.2)
		tween(r, 1.2, { Size = UDim2.fromOffset(22, 22) })
		tween(s, 1.2, { Transparency = 1 })
		task.delay(1.3, function() r:Destroy() end)
		task.wait(1.8)
	end
end)

local function updateGameBadge()
	local col, txt, st = C.muted, "...", C.stroke
	if gameState == true then
		col, txt, st = C.good, S("gameSupported"), Color3.fromRGB(46, 80, 56)
	elseif gameState == false then
		col, txt, st = C.err, S("gameUnsupported"), Color3.fromRGB(100, 48, 48)
	end
	tween(badgeDot, 0.3, { BackgroundColor3 = col })
	tween(badgeStroke, 0.3, { Color = st })
	badgeText.Text = txt
end

task.spawn(function()
	gameState = isGameSupported()
	updateGameBadge()
end)

do
	local final = badge.Position
	badge.Position = UDim2.new(final.X.Scale, final.X.Offset, final.Y.Scale, final.Y.Offset + 18)
	task.delay(0.9, function()
		tween(badge, 0.5, { Position = final }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
end

---------------------------------------------------------------------
-- KRYPTON HUB (V1.8.7)
---------------------------------------------------------------------
local function openHub(username, rank, expires, expiresAt)
	Authed = true
	local hub = new("Frame", {
		Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 50,
	}, gui)
	corner(hub, 14)
	stroke(hub, C.stroke, 1, 0.3)
	
	local toastFrame = new("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromOffset(600, 8), Size = UDim2.fromOffset(220, 36),
		BackgroundColor3 = Color3.fromRGB(8, 8, 9), BorderSizePixel = 0, ZIndex = 70, Visible = false,
	}, hub)
	corner(toastFrame, 8)
	stroke(toastFrame, Color3.fromRGB(30, 30, 34), 1)
	local toastBar = new("Frame", {
		Position = UDim2.fromOffset(12, 30), Size = UDim2.fromOffset(0, 2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 71,
	}, toastFrame)
	new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		})
	}, toastBar)
	local toastTitleLbl = label(toastFrame, "", 12, UDim2.fromOffset(12, 6), UDim2.fromOffset(120, 16), Color3.new(1, 1, 1), Enum.Font.GothamBold)
	toastTitleLbl.ZIndex = 72
	toastTitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
	local toastLbl = label(toastFrame, "", 11, UDim2.fromOffset(132, 6), UDim2.fromOffset(76, 16), Color3.new(1, 1, 1), Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	toastLbl.ZIndex = 72
	toastLbl.TextTruncate = Enum.TextTruncate.AtEnd
	local toastToken = 0
	local function showToast(titleText, statusText)
		toastToken += 1
		local currentToken = toastToken
		toastTitleLbl.Text = titleText
		toastLbl.Text = statusText
		toastBar.Size = UDim2.fromOffset(0, 2)
		toastFrame.Visible = true
		toastFrame.Position = UDim2.fromOffset(600, -30)
		tween(toastFrame, 0.3, { Position = UDim2.fromOffset(600, 8) }, Enum.EasingStyle.Back)
		tween(toastBar, 2, { Size = UDim2.fromOffset(196, 2) })
		task.delay(2.2, function()
			if toastToken == currentToken then
				tween(toastFrame, 0.3, { Position = UDim2.fromOffset(600, -30) })
				task.wait(0.35)
				if toastToken == currentToken then toastFrame.Visible = false end
			end
		end)
	end

	local hs = new("UIScale", {}, hub)
	local function us()
		local v = gui.AbsoluteSize
		hs.Scale = math.clamp(math.min(v.X / 720, v.Y / 480), 0.4, 1)
	end
	us()
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(us)
	makeParticles(hub, 640, 400, 14)
	local header = new("Frame", { Size = UDim2.fromOffset(640, 56), BackgroundTransparency = 1 }, hub)
	makeDraggable(hub, header)
	local hubLogo = makeLogo(hub, 36, UDim2.fromOffset(16, 10))
	local hubTitle = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(40, 10), Size = UDim2.fromOffset(180, 36),
		Text = "Krypton Hub", Font = Enum.Font.Michroma, TextSize = 16, TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = 1,
	}, hub)
	tween(hubTitle, 0.6, { TextTransparency = 0, Position = UDim2.fromOffset(60, 10) }, Enum.EasingStyle.Quint)
	label(hub, "v1.8", 10, UDim2.fromOffset(210, 25), UDim2.fromOffset(40, 14), C.muted, Enum.Font.Gotham)
	local sep = new("Frame", { Position = UDim2.fromOffset(0, 56), Size = UDim2.fromOffset(0, 1), BackgroundColor3 = C.stroke, BorderSizePixel = 0 }, hub)
	task.delay(0.3, function() tween(sep, 0.8, { Size = UDim2.fromOffset(640, 1) }, Enum.EasingStyle.Quint) end)
	task.spawn(function()
		local t = 0
		while alive(hub) do
			t += task.wait()
			hubLogo.Rotation = math.sin(t * 1.6) * 4
		end
	end)
	local setHub
	local hClose = new("TextButton", {
		Position = UDim2.fromOffset(596, 12), Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, ZIndex = 5,
	}, hub)
	local hX = Icons.cross(hClose, 16, 16, 11, C.muted)
	hClose.MouseEnter:Connect(function()
		for _, f in ipairs(hX:GetChildren()) do if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = C.text }) end end
		tween(hX, 0.3, { Rotation = 90 }, Enum.EasingStyle.Back)
	end)
	hClose.MouseLeave:Connect(function()
		for _, f in ipairs(hX:GetChildren()) do if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = C.muted }) end end
		tween(hX, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back)
	end)
	hClose.MouseButton1Click:Connect(function() setHub(false) end)
	local cats = {
		{ key = "catVisuals", icon = Icons.hubEye },
		{ key = "catAssist", icon = Icons.hubAim },
		{ key = "catPlayer", icon = Icons.hubUser },
		{ key = "catFarm", icon = Icons.hubFarm },
		{ key = "catMisc", icon = Icons.hubGear },
		{ key = "catCustom", icon = Icons.hubPalette },
	}
	local TXT_OFF = Color3.fromRGB(150, 150, 158)
	local TXT_HOVER = Color3.fromRGB(205, 205, 212)
	local side = new("Frame", { Position = UDim2.fromOffset(14, 66), Size = UDim2.fromOffset(150, 280), BackgroundTransparency = 1 }, hub)
	local pill = new("Frame", { Size = UDim2.fromOffset(150, 36), BackgroundColor3 = C.tabSel, BorderSizePixel = 0 }, side)
	corner(pill, 6)
	local pillStroke = stroke(pill, C.stroke, 1)
	local pillBar = new("Frame", { Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(3, 26), BackgroundColor3 = ACCENT, BorderSizePixel = 0 }, pill)
	corner(pillBar, 2)
	task.spawn(function()
		while alive(hub) do
			tween(pillBar, 0.9, { Size = UDim2.fromOffset(3, 18), Position = UDim2.fromOffset(0, 9) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(pillStroke, 0.9, { Transparency = 0.5 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(0.9)
			tween(pillBar, 0.9, { Size = UDim2.fromOffset(3, 26), Position = UDim2.fromOffset(0, 5) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(pillStroke, 0.9, { Transparency = 0 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(0.9)
		end
	end)
	local pages = {}
	local trList, onLang = {}, {}
	local applyLang
	local refreshVisualsUI
	local refreshDD = function() end
	local loadedProfileName = nil
	local function reg(lbl, key)
		trList[#trList + 1] = { lbl = lbl, key = key }
		lbl.Text = S(key)
		return lbl
	end
	local function comingSoon(catKey)
		local pgC = new("CanvasGroup", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgC
		local catDef
		for _, c in ipairs(cats) do if c.key == catKey then catDef = c break end end
		local ico = catDef.icon(pgC, 0, 0, Color3.fromRGB(80, 80, 88), C.bg)
		ico.AnchorPoint = Vector2.new(0.5, 0.5)
		ico.Position = UDim2.fromOffset(223, 104)
		new("UIScale", { Scale = 2.6 }, ico)
		reg(label(pgC, "", 22, UDim2.fromOffset(0, 156), UDim2.fromOffset(446, 28), C.text, CAT_FONT, Enum.TextXAlignment.Center), catKey)
		reg(label(pgC, "", 12, UDim2.fromOffset(0, 184), UDim2.fromOffset(446, 18), C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Center), "comingSoonTitle")
		task.spawn(function()
			while alive(ico) do
				tween(ico, 1.4, { Position = UDim2.fromOffset(223, 98) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.4)
				tween(ico, 1.4, { Position = UDim2.fromOffset(223, 110) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.4)
			end
		end)
	end
	local SUB_W = 88
	local function makeSubTabs(parent, keys, callback)
		local subBar = new("Frame", {
			Position = UDim2.fromOffset(0, 32), Size = UDim2.fromOffset(4 + #keys * SUB_W, 28),
			BackgroundColor3 = C.tabBg, BorderSizePixel = 0,
		}, parent)
		corner(subBar, 8)
		stroke(subBar, C.stroke, 1)
		local subPill = new("Frame", {
			Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(SUB_W, 24),
			BackgroundColor3 = C.tabSel, BorderSizePixel = 0, ZIndex = 1,
		}, subBar)
		corner(subPill, 6)
		local subBtns = {}
		local function showSubTab(idx)
			callback(idx)
			for i, b in ipairs(subBtns) do
				tween(b, 0.2, { TextColor3 = (i == idx) and C.text or C.muted })
			end
			tween(subPill, 0.3, { Position = UDim2.fromOffset(2 + (idx - 1) * SUB_W, 2) }, Enum.EasingStyle.Back)
		end
		for i, key in ipairs(keys) do
			local b = new("TextButton", {
				Position = UDim2.fromOffset(2 + (i - 1) * SUB_W, 2), Size = UDim2.fromOffset(SUB_W, 24),
				BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 11,
				TextColor3 = (i == 1) and C.text or C.muted, AutoButtonColor = false, ZIndex = 2,
			}, subBar)
			reg(b, key)
			subBtns[i] = b
			b.MouseButton1Click:Connect(function() showSubTab(i) end)
		end
	end
	local function miscPage()
		local pgM = new("Frame", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgM
		reg(label(pgM, "", 20, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 28), C.text, CAT_FONT), "catMisc")
		local subPagesM = {}
		makeSubTabs(pgM, { "subSettings", "subProfils", "subTranslation" }, function(idx)
			for i, p in ipairs(subPagesM) do p.Visible = (i == idx) end
		end)
		local pSet = new("Frame", { Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = true }, pgM)
		subPagesM[1] = pSet
		local card = new("Frame", {
			Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(446, 64),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pSet)
		corner(card, 10)
		stroke(card, C.stroke, 1)
		Icons.key(card, 16, 23, ACCENT)
		reg(label(card, "", 14, UDim2.fromOffset(46, 12), UDim2.fromOffset(280, 20), C.text, CAT_FONT), "resetHwid")
		reg(label(card, "", 11, UDim2.fromOffset(46, 35), UDim2.fromOffset(280, 16), C.muted, Enum.Font.Gotham), "resetDesc")
		local btn = new("TextButton", {
			Position = UDim2.fromOffset(334, 17), Size = UDim2.fromOffset(100, 30), BackgroundColor3 = C.field,
			Text = S("resetBtn"), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text, AutoButtonColor = false,
		}, card)
		corner(btn, 8)
		local btnSt = stroke(btn, C.stroke, 1)
		local busy, armed = false, false
		local function idle()
			btn.Text = S("resetBtn")
			tween(btn, 0.15, { BackgroundColor3 = C.field })
			tween(btnSt, 0.15, { Color = C.stroke })
		end
		onLang[#onLang + 1] = function() if not busy and not armed then btn.Text = S("resetBtn") end end
		btn.MouseEnter:Connect(function()
			if not busy and not armed then tween(btn, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 34) }) end
		end)
		btn.MouseLeave:Connect(function()
			if not busy and not armed then tween(btn, 0.15, { BackgroundColor3 = C.field }) end
		end)
		btn.MouseButton1Click:Connect(function()
			if busy then return end
			if not armed then
				armed = true
				btn.Text = S("resetConfirm")
				tween(btn, 0.15, { BackgroundColor3 = Color3.fromRGB(58, 30, 30) })
				tween(btnSt, 0.15, { Color = C.err })
				task.delay(3, function()
					if armed and not busy then
						armed = false
						idle()
					end
				end)
				return
			end
			armed = false
			busy = true
			btn.Text = S("resetting")
			task.spawn(function()
				local ok = resetHwid(username)
				btn.Text = ok and S("resetOk") or S("resetFail")
				tween(btn, 0.2, { BackgroundColor3 = ok and Color3.fromRGB(28, 54, 36) or Color3.fromRGB(58, 30, 30) })
				tween(btnSt, 0.2, { Color = ok and C.good or C.err })
				task.wait(2.2)
				busy = false
				idle()
			end)
		end)
		local pProf = new("Frame", { Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = false }, pgM)
		subPagesM[2] = pProf
		local profilesHeaderLbl = label(pProf, "", 13, UDim2.fromOffset(0, 0), UDim2.fromOffset(320, 20), C.text, CAT_FONT)
		local function loadProfilesList()
			if not (isfile and isfile(Config.ProfilesFile) and readfile) then return {} end
			local ok, res = pcall(function() return HttpService:JSONDecode(readfile(Config.ProfilesFile)) end)
			if ok and type(res) == "table" then
				if res.profiles and type(res.profiles) == "table" then return res.profiles end
				local migrated = {}
				for k, v in pairs(res) do
					if tonumber(k) and type(v) == "table" then
						table.insert(migrated, { name = "Profile " .. k, data = v })
					end
				end
				return migrated
			end
			return {}
		end
		local function saveProfilesList(list)
			if not writefile then return end
			pcall(function() writefile(Config.ProfilesFile, HttpService:JSONEncode({ profiles = list })) end)
		end
		onLang[#onLang + 1] = function()
			profilesHeaderLbl.Text = string.format(S("profilesCount"), #loadProfilesList())
		end
		local profScroll = new("ScrollingFrame", {
			Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(446, 212),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(80, 80, 88), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
		}, pProf)
		new("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
		}, profScroll)
		local renderProfilesList
		local addBtn = new("TextButton", {
			Position = UDim2.fromOffset(418, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		}, pProf)
		local addIconObj = Icons.plus(addBtn, C.muted)
		addBtn.MouseEnter:Connect(function() tintIcon(addIconObj, C.text) end)
		addBtn.MouseLeave:Connect(function() tintIcon(addIconObj, C.muted) end)
		addBtn.MouseButton1Click:Connect(function()
			local list = loadProfilesList()
			if #list >= 10 then return end
			table.insert(list, { name = S("newProfileName"), data = HttpService:JSONDecode(HttpService:JSONEncode(Settings.Visuals)) })
			saveProfilesList(list)
			renderProfilesList()
			showToast(S("newProfileName"), S("toastCreated"))
		end)
		local eraseBtn = new("TextButton", {
			Position = UDim2.fromOffset(384, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		}, pProf)
		local eraseIconObj = Icons.eraser(eraseBtn, C.muted)
		eraseBtn.MouseEnter:Connect(function() tintIcon(eraseIconObj, C.text) end)
		eraseBtn.MouseLeave:Connect(function() tintIcon(eraseIconObj, C.muted) end)
		eraseBtn.MouseButton1Click:Connect(function()
			if loadedProfileName ~= nil then
				for k, _ in pairs(Settings.Visuals) do Settings.Visuals[k] = false end
				Settings.Visuals.snapPos = "Bottom"
				Settings.Visuals.adminAlert = false
				if refreshVisualsUI then refreshVisualsUI() end
				showToast(loadedProfileName, S("toastReset"))
				loadedProfileName = nil
			end
		end)
		renderProfilesList = function()
			for _, ch in ipairs(profScroll:GetChildren()) do
				if ch:IsA("Frame") then ch:Destroy() end
			end
			local list = loadProfilesList()
			profilesHeaderLbl.Text = string.format(S("profilesCount"), #list)
			for idx, prof in ipairs(list) do
				local row = new("Frame", {
					Size = UDim2.fromOffset(440, 40), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = idx,
				}, profScroll)
				corner(row, 8)
				stroke(row, C.stroke, 1)
				local nameLbl = label(row, prof.name, 12, UDim2.fromOffset(12, 0), UDim2.fromOffset(210, 40), C.text, Enum.Font.GothamMedium)
				nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
				local function createActionButton(x, iconFn, hoverCol, cb)
					local b = new("TextButton", {
						Position = UDim2.fromOffset(x, 6), Size = UDim2.fromOffset(28, 28),
						BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
					}, row)
					local ico = iconFn(b, C.muted)
					b.MouseEnter:Connect(function() tintIcon(ico, hoverCol or C.text) end)
					b.MouseLeave:Connect(function() tintIcon(ico, C.muted) end)
					b.MouseButton1Click:Connect(cb)
					return b
				end
				createActionButton(246, Icons.download, C.text, function()
					pcall(function()
						if prof.data then
							for k, v in pairs(prof.data) do
								if Settings.Visuals[k] ~= nil then Settings.Visuals[k] = v end
							end
							loadedProfileName = prof.name
							if refreshVisualsUI then refreshVisualsUI() end
							showToast(prof.name, S("toastLoaded"))
						end
					end)
				end)
				createActionButton(278, Icons.floppy, C.text, function()
					pcall(function()
						prof.data = HttpService:JSONDecode(HttpService:JSONEncode(Settings.Visuals))
						saveProfilesList(list)
						showToast(prof.name, S("toastSaved"))
					end)
				end)
				local renameBtn = new("TextButton", {
					Position = UDim2.fromOffset(310, 6), Size = UDim2.fromOffset(28, 28),
					BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
				}, row)
				local renameIconObj = Icons.pencil(renameBtn, C.muted)
				renameBtn.MouseEnter:Connect(function() tintIcon(renameIconObj, C.text) end)
				renameBtn.MouseLeave:Connect(function() tintIcon(renameIconObj, C.muted) end)
				local isRenaming = false
				local renameBox
				renameBtn.MouseButton1Click:Connect(function()
					pcall(function()
						if not isRenaming then
							isRenaming = true
							nameLbl.Visible = false
							for _, ch in ipairs(renameBtn:GetChildren()) do ch:Destroy() end
							renameIconObj = Icons.check(renameBtn, C.text)
							renameBox = new("TextBox", {
								Position = UDim2.fromOffset(12, 6), Size = UDim2.fromOffset(210, 28),
								BackgroundTransparency = 1, Text = prof.name, TextColor3 = C.text,
								Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
								ClearTextOnFocus = false,
							}, row)
							renameBox.FocusLost:Connect(function()
								pcall(function()
									if isRenaming then
										isRenaming = false
										local newN = renameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
										if newN ~= "" then
											local oldN = prof.name
											prof.name = string.sub(newN, 1, 20)
											if loadedProfileName == oldN then loadedProfileName = prof.name end
											saveProfilesList(list)
										end
										renameBox:Destroy()
										nameLbl.Text = prof.name
										nameLbl.Visible = true
										for _, ch in ipairs(renameBtn:GetChildren()) do ch:Destroy() end
										renameIconObj = Icons.pencil(renameBtn, C.muted)
										showToast(prof.name, S("toastRenamed"))
										renderProfilesList()
									end
								end)
							end)
							renameBox:CaptureFocus()
						else
							if renameBox then renameBox:CaptureFocus() end
						end
					end)
				end)
				createActionButton(342, Icons.trash, Color3.fromRGB(255, 130, 130), function()
					pcall(function()
						if loadedProfileName == prof.name then loadedProfileName = nil end
						table.remove(list, idx)
						saveProfilesList(list)
						renderProfilesList()
						showToast(prof.name, S("toastDeleted"))
					end)
				end)
			end
		end
		renderProfilesList()
		local pTrans = new("Frame", { Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = false }, pgM)
		subPagesM[3] = pTrans
		local tCard = new("Frame", {
			Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(446, 64),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pTrans)
		corner(tCard, 10)
		stroke(tCard, C.stroke, 1)
		Icons.globe(tCard, 16, 23, ACCENT)
		reg(label(tCard, "", 14, UDim2.fromOffset(46, 12), UDim2.fromOffset(280, 20), C.text, CAT_FONT), "language")
		reg(label(tCard, "", 11, UDim2.fromOffset(46, 35), UDim2.fromOffset(280, 16), C.muted, Enum.Font.Gotham), "chooseLang")
		local langRefs = {}
		for idx, code in ipairs({ "FR", "EN" }) do
			local b = new("TextButton", {
				Position = UDim2.fromOffset(350 + (idx - 1) * 44, 18), Size = UDim2.fromOffset(36, 28),
				BackgroundColor3 = C.field, Text = code, Font = Enum.Font.GothamBold, TextSize = 12,
				TextColor3 = C.muted, AutoButtonColor = false,
			}, tCard)
			corner(b, 7)
			local st = stroke(b, C.stroke, 1)
			langRefs[code] = { b = b, st = st }
			b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 34) }) end)
			b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = C.field }) end)
			b.MouseButton1Click:Connect(function()
				currentLang = code
				saveLang()
				applyLang()
			end)
		end
		onLang[#onLang + 1] = function()
			for code, r in pairs(langRefs) do
				local on = (code == currentLang)
				r.b.TextColor3 = on and C.text or C.muted
				tween(r.st, 0.2, { Color = on and C.text or C.stroke })
			end
		end
	end
	local function visualsPage()
		local V = Settings.Visuals
		local pgF = new("Frame", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgF
		reg(label(pgF, "", 20, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 28), C.text, CAT_FONT), "catVisuals")
		local subPagesV = {}
		makeSubTabs(pgF, { "subGeneral", "subAdvanced" }, function(idx)
			for i, p in ipairs(subPagesV) do p.Visible = (i == idx) end
		end)
		local pgGeneral = new("Frame", {
			Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(4
