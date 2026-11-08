--[[
    KRYPTON LAUNCHER - Loader UI (LocalScript unique)  |  v1.8.8
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
-- CONFIG & THÈME
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
	SupportedPlaceIds = { 136801880565837, 84448037861644 },
}

local C = {
	bg = Color3.fromRGB(15, 15, 18),
	panel = Color3.fromRGB(22, 22, 27),
	field = Color3.fromRGB(28, 28, 35),
	stroke = Color3.fromRGB(45, 45, 58),
	text = Color3.fromRGB(255, 255, 255),
	muted = Color3.fromRGB(140, 140, 155),
	err = Color3.fromRGB(255, 95, 95),
	good = Color3.fromRGB(110, 231, 140),
	discord = Color3.fromRGB(88, 101, 242),
}

-- THÈMES DE PERSONNALISATION DU HUB (Standard & Avancés Premium)
local Themes = {
	Original = { nameKey = "themeOriginal", accent = Color3.fromRGB(255, 255, 255), stroke = Color3.fromRGB(45, 45, 58), field = Color3.fromRGB(28, 28, 35), premium = false },
	Ruby = { nameKey = "themeRuby", accent = Color3.fromRGB(70, 130, 255), stroke = Color3.fromRGB(40, 60, 100), field = Color3.fromRGB(22, 30, 45), premium = false },
	Kaki = { nameKey = "themeKaki", accent = Color3.fromRGB(130, 180, 100), stroke = Color3.fromRGB(50, 70, 45), field = Color3.fromRGB(25, 33, 22), premium = false },
	Emerald = { nameKey = "themeEmerald", accent = Color3.fromRGB(50, 220, 140), stroke = Color3.fromRGB(30, 70, 50), field = Color3.fromRGB(18, 32, 25), premium = false },
	Sapphire = { nameKey = "themeSapphire", accent = Color3.fromRGB(90, 100, 255), stroke = Color3.fromRGB(45, 50, 95), field = Color3.fromRGB(22, 24, 42), premium = false },
	Amethyst = { nameKey = "themeAmethyst", accent = Color3.fromRGB(190, 100, 255), stroke = Color3.fromRGB(70, 40, 95), field = Color3.fromRGB(32, 20, 42), premium = true },
	Sunset = { nameKey = "themeSunset", accent = Color3.fromRGB(255, 140, 70), stroke = Color3.fromRGB(95, 55, 35), field = Color3.fromRGB(42, 26, 20), premium = true },
	Cyberpunk = { nameKey = "themeCyberpunk", accent = Color3.fromRGB(255, 50, 120), stroke = Color3.fromRGB(95, 30, 55), field = Color3.fromRGB(42, 18, 28), premium = true },
	RoseGold = { nameKey = "themeRoseGold", accent = Color3.fromRGB(255, 180, 190), stroke = Color3.fromRGB(95, 65, 70), field = Color3.fromRGB(42, 28, 32), premium = true },
	Arctic = { nameKey = "themeArctic", accent = Color3.fromRGB(120, 230, 255), stroke = Color3.fromRGB(45, 75, 85), field = Color3.fromRGB(20, 32, 38), premium = true },
}

local currentThemeKey = "Original"

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
		adminAlertTitle = "Security System - Anti-Admin",
		adminAlertDesc = "Administrator presence detected — Automated safety protocol initiating in %ds...",
		adminAlertDescDone = "Security protocol engaged: All modules deactivated to protect session integrity.",
		adminAlertOptDesc = "Emergency Override: Force-disable active cheats for enhanced security",
		espMaxDist = "ESP Max Distance",
		secSystemCat = "Security System",
		advancedEspCat = "Advanced ESP",
		catVisuals = "Visuals", catAssist = "Assistance", catPlayer = "Player", catFarm = "Farm", catMisc = "Misc", catCustom = "Customize",
		subGeneral = "General", subAdvanced = "Advanced",
		subMenu = "Menu", subLogo = "Logo",
		subSettings = "Settings", subProfils = "Profiles", subTranslation = "Translation",
		settingsTitle = "Settings",
		profilesCount = "Saved Profiles (%d/10)",
		newProfileName = "New Profile",
		toastCreated = "CREATED", toastSaved = "SAVED", toastLoaded = "LOADED", toastRenamed = "RENAMED", toastDeleted = "DELETED", toastReset = "RESET",
		noRequest = "Executor HTTP request not supported.",
		errServer = "Server communication error.",
		getKeyBtn = "Join the Discord",
		-- Personnalisation & Thèmes
		enableAdvCustom = "Enable Advanced Customize",
		premiumError = "This Feature is only for Premium Member",
		customPaletteTitle = "Custom Color Palette",
		customPaletteDesc = "Pick an exact RGB color for your hub",
		applyBtn = "Apply",
		activeBtn = "Active ✓",
		themeOriginal = "Original (White)",
		themeRuby = "Ruby Blue",
		themeKaki = "Kaki Green",
		themeEmerald = "Emerald",
		themeSapphire = "Deep Sapphire",
		themeAmethyst = "Amethyst",
		themeSunset = "Sunset",
		themeCyberpunk = "Cyberpunk Neon",
		themeRoseGold = "Rose Gold",
		themeArctic = "Arctic Ice",
		-- Palette / Rainbow / Logo
		applyChanges = "Apply Changes",
		toastApplied = "APPLIED",
		rainbowEsp = "Rainbow ESP",
		rainbowMenu = "Rainbow Menu",
		changeLogo = "Change Logo",
		changeLogoDesc = "Choose a premium logo style",
		logoOriginal = "Original",
		logoGold = "Pure Gold",
		logoSilver = "Pure Silver",
		logoRuby = "Ruby Red",
		logoSapphire = "Sapphire Blue",
		logoEmerald = "Emerald Green",
		logoAmethyst = "Amethyst Purple",
		logoNeon = "Neon Pink",
		logoIce = "Ice Cyan",
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
		adminAlertTitle = "Système de sécurité - Anti-Admin",
		adminAlertDesc = "Présence d'un administrateur — Protocole de sécurité automatique dans %ds...",
		adminAlertDescDone = "Sécurité activée : Tous les modules ont été désactivés pour protéger la session.",
		adminAlertOptDesc = "Désactivation d'urgence : Neutraliser les scripts actifs pour une sécurité accrue",
		espMaxDist = "Distance maximale ESP",
		secSystemCat = "Système de sécurité",
		advancedEspCat = "Advanced ESP",
		catVisuals = "Visuels", catAssist = "Assistance", catPlayer = "Joueur", catFarm = "Farm", catMisc = "Misc", catCustom = "Personnaliser",
		subGeneral = "Général", subAdvanced = "Avancé",
		subMenu = "Menu", subLogo = "Logo",
		subSettings = "Paramètres", subProfils = "Profils", subTranslation = "Traduction",
		settingsTitle = "Paramètres",
		profilesCount = "Profils sauvegardés (%d/10)",
		newProfileName = "Nouveau Profil",
		toastCreated = "CRÉÉ", toastSaved = "SAUVEGARDÉ", toastLoaded = "CHARGÉ", toastRenamed = "RENOMMÉ", toastDeleted = "SUPPRIMÉ", toastReset = "RÉINITIALISÉ",
		noRequest = "Requête HTTP non supportée par l'executor.",
		errServer = "Erreur de communication avec le serveur.",
		getKeyBtn = "Rejoindre le Discord",
		-- Personnalisation & Thèmes
		enableAdvCustom = "Activer la personnalisation avancée",
		premiumError = "This Feature is only for Premium Member",
		customPaletteTitle = "Palette de couleurs personnalisée",
		customPaletteDesc = "Choisis une couleur RGB précise pour ton hub",
		applyBtn = "Appliquer",
		activeBtn = "Actif ✓",
		themeOriginal = "Original (Blanc)",
		themeRuby = "Bleu Rubis",
		themeKaki = "Vert Kaki",
		themeEmerald = "Émeraude",
		themeSapphire = "Saphir Profond",
		themeAmethyst = "Améthyste",
		themeSunset = "Coucher de soleil",
		themeCyberpunk = "Néon Cyberpunk",
		themeRoseGold = "Or Rose",
		themeArctic = "Glace Arctique",
		-- Palette / Rainbow / Logo
		applyChanges = "Appliquer le changement",
		toastApplied = "APPLIQUÉ",
		rainbowEsp = "Rainbow ESP",
		rainbowMenu = "Rainbow Menu",
		changeLogo = "Modifier le logo",
		changeLogoDesc = "Choisis un style de logo premium",
		logoOriginal = "Original",
		logoGold = "Or Pur",
		logoSilver = "Argent Pur",
		logoRuby = "Rouge Rubis",
		logoSapphire = "Bleu Saphir",
		logoEmerald = "Vert Émeraude",
		logoAmethyst = "Violet Améthyste",
		logoNeon = "Rose Néon",
		logoIce = "Cyan Glacé",
	},
}

local currentLang = Config.DefaultLanguage

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
		maxDistance = 1000,
	},
}
pcall(function() if getgenv then getgenv().KryptonSettings = Settings end end)

local Authed = false
local Session = { password = "" }

---------------------------------------------------------------------
-- DÉCODEUR BASE64 & CHARGEMENT DES ASSETS
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
			bits = bits + (6)
			if bits >= 8 then
				bits = bits - (8)
				local p = 2 ^ bits
				local byte = math.floor(buf / p)
				buf = buf % p
				n = n + (1)
				out[n] = string.char(byte)
			end
		end
	end
	return table.concat(out)
end

local EMBED_LOGO = ""
local EMBED_DISCORD = ""
local EMBED_ICONS = {
	k = "iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAABGJUlEQVR42u29eZwV5Zkv/jzvW1VnX3oDGpAdgcYFUGYFG+OCCuzoysZkZYzITJzHrLPd3M/PJLNf25AnxiZg0oCISZCHHl1gasLAICeWJ4BvwsAOqOYot5aJKANJi2+AOiAMo66e0THRuxuVUl4jCV4kxzS8lHp+NDcqQZIBhSXlaYYWRe8Dgc6ELhm41X3LnTCOhkVd75UNhFkKqtylabKJB/LC53jg30CaOTsqQmsjWJqwDJxjYxVg78KEoWZxgAOwcMFAC1gnzDWB1dd/hmPLue8xIcAJmAFtpfs84+JaBo7qzVxgC9TiDAwdem/k8mKS6Z9QAH1bPR9gr2qLtKvZ752GF/Zjy5uWt2lXAAAAAElFTkSuQmCC",
	download = "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",
	save = "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",
	pencil = "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",
	trash = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAE1ElEQVR42uWb24scRRTGf909O8Y1uOpDFoQgSjRiFCFBogHxyQuoCOKrT/5R/gm+iA+C+OIFIqJoFFEQiQnEGFGCuyRx5z7T5UOfwrO1c+mu7pqpxoJmLzNTl6++89U5Z+okxhgCtw6QAanHZw2QAzN5Gm9JQAASWUCs/YHnrlSddIx9HaJnqEXb3XoCOAvsAl31WrKE9na3B8BvwLfAH/J6JmZh2gDADvAq8DZwWgFQth3I4t8F3pc+UwFgrQxI1ZM4i0wW2OkOcA54EXjKc37HgWeBK8A14FdgLCxwNcE489ICauoCkHugfhp4RRZvgCkwKTmmkYl3gbuBC8BV4Dpwa90i6Cs+DwLPASekj0wW1Cn5dOUzAKeECfc0LaBld2NLRGwX2F7QYSL9TeTvl4FHBOSZpy9gmXAXcAZ4A/hOXttSY7kmMAP+Af4E9paxd5EfoO2rCzwKvAa8BDysdmaZmt8rOtDU8TUF9oHhEjO1AA+An4EPgU/lBMkV6/NVDMhkQICHgNeBN4FnPL25uiDkMtcTFT5zUpiTCBB788yhU0IbTgn1zm7QgfFx2LaBF4Ae8JUCINVudafEpHeEBZYVQ2XTqyad0Vwzq440hy3bIpon5SShCgP0IPvAZeABodRx2tNuiQ/RW7C2hdTSkddl4APxyEyLFn9HBPAj4KbDkJUM0G+6AXwsi99T5hAbGEZ5qQPgF1n8ReD2IgDKhsMZcL88x5a4wjEAYBncF/O9s2yzygCQtIz6ldaQlkS27c3UPV9TldpqS9tSUWNjKbGkTKcRtJySOcQywVCmOrsPeAd4XPnnnUjs284lAT4B3lNrXOhAdUrSf6YSFG8B5yNnwFQBkC5LofmEp70W2P+gbCxSNh9g20Qco4F0nBM+s1z2/LfxSd/x/ExdANzBchloi8MZ3GTDANjNOOBorrBRAEYUickuRxOimxTCVLnB41Bxts3V9yN0ciwT+0uyRrU9wVwAGKr/x+QpzmR+I2f+pkkGDB0AiByAxk1gHgAmMgCCaUAu6I4iZUAumzMJyYC+oJxHsmjjeIC9pkVwHsIxa8CwaQ0wc47BmAHozzkFgotgTBoQ9BSI0QTMHAYE9wQHER+DazMBItWAYdMMMC0zgbVowCgiP2CeCAbVgP4cDYjJBFxHqNFgiP+jI+QmPIaRhcMmdDBknPeOWxANupvWKANmLXCFgwJA5NGgywATAoAxcbbcEcBgDJhGxIDEAWASCgDX1sYRAjCuujG+AEyV2NicvIkAgMpBWhUATB21XRMAlU+nOiYw2DAAZsHxvDYTOJCfSSQaMJA4YC0MyEVwphGJoP3OMhgAq3xus0EzsF/aumG6CcWAiQo781UhZ2AAjArTD6hYX+jLgB5FNddN/iunWTcIdryZ7Px14HfHLFfOp+MBQEpxCfkiRVHUk0oXZhz9urppe9eXMez8M+B7imqSESvuBfkyIFeD3Qa+AC45J4O9Ip85vzf1pBwuvbELvCHz+VHMMwvJAKN04HOKgooz+NUF1mkpxeXtn4AvgR98kjQ+tcOWXilFIcJjwPPyPE1RYAFh7g3lyu3+C/gG+Az4mqIuaErF4so6xdPWHm0tzy7FbfJuQAD0pawh8DdFZdi+r+7UrR5vtIy1pjgmPnP5F72g4QScu+SwAAAAAElFTkSuQmCC",
	plus = "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",
	eraser = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAJKElEQVR42u2ba4xdVRXHf+fcc2f6AlosLdIoj7ZWKghWi8aAjZICRhMNCKIwaG0hmGiwMTExoh+NJr6iJiYaeSil2AIGxA9ETUS+mIhYYCh2OrRV64Nqp8P0MY9771l+mP+Oi829d+7rjFPrTk7m3nPPY6/Xf/3X2nsSM+NUHimn+DjlFZDNkXkkMkaqzwAG5DoKi9NkDmBA0oKASVFKSOdACGZAqck1JV2T/q95QAmoue9LgNcBS2XxEeAg8M/onp6GxFzBgNcC7wI2ApdI0EHgV8CvgT+5a+1k9oDEWd6A04EPSfgLgDcAy3Xtv4AhYB/wW2AncMgZrtYTZZjZbB6J+7zIzG4ws132ylHV4cewmW02szMaPKvjY7Y8INGRAVNAH7AFuBW4eAYQDOOPwN3A94CjekatW0zIZhHwqhJ+KXA1MABcqt/HNZfEKSNwgCowH3gjcDMwCjwG/K0n4TALLp+YWabvmZltMrPdkZvn1nj432pmts/M7jCzBXpm2b2n7TlmswR4VWAxcAPwMeBCXVPRNWkLJKgKlIHzgVt0fjvwkq4r63lzKgSq+rsAuAb4NHCRXBvn9q0oM3Pxvk4KPQbsAMY6Eb6oNBgDXj+wWcelztp5B+zO3DsAXgDuFTCO6Z3WDjAW4QGp3D4A3ka5/Tr9PikETzpUrsnamUJpADgM/Bz4e7uMMS3A8qlT7geAO53wOOGTLt7jQ+dC4PPAh5UtcJkkmS0PSFyqqwBnAtfJ8mvbALxOPKFPLHJAVt/pPGFGYMwKALx5yvOfkfA1V/UlPfa4shRRk5ctASaUHY62Aoy9AMGSjikJ/wkd66I6PqGYYTqCZz0P/Aj4vkhTU2BMeyB8ALzXAB8ENgFvlcCT7qVFce6AJxW9403AxxWCy+WZtUaypl2+NHOhdC3wRUdvQwxSdFurDjCuETDeLA4SjPUq8M26sHxVFg6W94A35UKjWR4vIhwCMK4EbtIcH2oEjN1iQL9c7U6lo9wJl0TWT2apBWfuvSVgP/BVYJuY4yv6i1kHlk9k/QWKtU2O24dskOraY8Ae4C/ACmC9uyZpsQzutsl6PvApNV9+qFZbGsCzHQWkrod3phjeZqG9Z2eZA6WngEfU1VkLLFLXxyNzWpASUsc9LlJmGgF+5jpLaTslbb8raW8zs+fMrOJK1YpK3Fxl61NmdruZLTaz+Wa22sy+pFI4lLmTM5TC3Y5a9HnYzLaaWSpZ+tIW3d4EJkuFrLdIq5nOe7fPgd8D9wCPKxePA3uBh1W9DclKfY7IUGA4jGt+K4ErgNeHubYSArnj8FcDn3OAl7pUF0LkWeAB4D4JHxjblDq9gRvcBKzWfdUCFRBj3bnABnWVDqczxHyw6ELF+x0O8MyRjwAqz4iBPSjhcb+FyQwLkbeJtYUJVgv0hNR52gXCrxXNskDqLL8EuEoNzLe47kzJAV5Vlr9fbn4oosg15y0VKWGH7p0HnOeA0QrgCYk7FgNvBpY1U0CwfBm4Efiks3ziYiv8HQTukusf1nU1p8QQSr44GRJnN7XKfNVYLpAsNa0GA7evSEPXCPQuds2MsE4XvGSXBHlMwgdwm6pDfy3iEvsULgnwUWCV7s0dkellwWQKzWdDKsya5PrLBHhrnbXLzgNyWX672lKjLqdPNplMLYr7552yigLG3IXkPuAXwF/rKaAm4c5WUbNW36dcTR/GIPADtaJG62BHK1YJ1++VIgGuV0WXOWWVurA8rqMM0+uMT4RSOYvyZa620mXA21x+T90DJ5hepXlQQBYDXquj5sKlIkzY4Zoq50W9vaRDBaSSKVdd8CTwZ33vyyLLmejq5VJAOaKrE4r5baK4h5ww1uEEqxEw3hd5QuJodtrms2tOviHga6LCwUur9bLAPDGmFU7ziStzgwsd1LmFwIk2XL9RfAZgfNEBY58DxiBQqUXhc+f2gwLqn0bFUJ42cM0x4HgdtyvJQ8525yo9aHbUHLcA2C1P2CZ8iFlpK3Efxn7gu1o7GHEAbkSxHW48Li6/WxPzR79S4gDwfkdxS07bvWJtw+IV92suSdRhapTqKq7U/gPwDeBRleavAv6sTqfmuIBijXp7JRenZXHp6+QJoyp5JyJi1I0n4IBxD/ATnfuI3t3f5B2J4xH75UF3KUTDM6vNFBCEfUHaO6ZGQs1VhYni/j06/2MHLP094vR+ki8qRU7I697h5uIzWNVR8z3A10XOTjQD6kZUeFKW3Qm8z8V8JeLU75Xgo8DT8h7PKLshLmH32KQQ/HdKz+biOHGuX47a4g/VaYvP2BX2aWMQ+IqQcyJaAQpjkejyVuCdUYe2F/TVh95K4JxozhZhwn7g2wK8UedNDdN01gBBAxUdZnpbSlVF0Vl1FHUGcKWaDgnTu7omXTnd7rK17x/A9A6yjcKdVRHbrCq2M3ngvQrHo/U6wPXV3LwNVtL31WZ2j5kdjXZuVFzb6WUze9jMrjCzPt2XtrmhKYl2e8w3swEz+03UfqvW2TWy1e0a6Wt110jWxP0SZ+m9ApUR4DaBYCVyx9OBd+v8YgeM892zZqKzwWOm9IxrlXLXR4CdRHn+W6pJxl1KTpsQpP+U6i1YpM99v8TM7jazf0TN0IqzypiZPWBmlzuLtHssNbMbzewJNU6D1SuuiXrEzJ40s1u72cfU7t6+kpmtMrPvmNm4JjKlSXm3PKJwuKqDSZXMbEskvO/wBgXsMrPru93IlbWIxh6YhpVmEhUsyyJgLMl9r5TbrtczsiapMS7GNoiE9Tm3jVeclqjDu0xAXK7TQ7BohWpEHOc54Ei7S2NJ1DRZBXxBSlhY0Ppfr/uDLzG9/3i72O7LWQeTyV1395vS5BbgNJdzAyWda2O5Umqu5bpnOlkcTVw7y1QcfVaEaHl0baVDHlCKGjGN2GKtRcYZehqBMxwAbgcezzp0y6pz9d3Al6MUSQ9YYd5C+dvq84MCQjiNB8V1Q1k9MA6p8jqiPuK5woiz5mAYHFBT9GC7INisfvd8fI3qgg3A26WMhOJWglsF0VzC/1JF3tPAiSIUgFLTOcKE0+aA1UPVOCbLHwhlci+3ymauiMo5SUav9woX9u9tRY2soJhLW0hj/43h/xkzL8IDTrrx/3+ePtUV8G997pV732e1AwAAAABJRU5ErkJggg==",
	gear = "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",
	check = "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",
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

local LogoAsset = resolveImage(Config.LogoFile, Config.LogoImage, EMBED_LOGO, "krypton_logo_v18.png")
local DiscordAsset = resolveImage(Config.DiscordFile, Config.DiscordImage, EMBED_DISCORD, "krypton_discord.jpg")

local IconAssets = {}
for _, name in ipairs({ "eye", "aim", "user", "farm", "palette" }) do
	IconAssets[name] = resolveImage("", "", "", "krypton_ico_" .. name .. "_v1.png")
end
IconAssets.k = resolveImage("", "", EMBED_ICONS.k, "krypton_ico_k_v2.png")
IconAssets.download = resolveImage("", "", EMBED_ICONS.download, "krypton_ico_download_v4.png")
IconAssets.floppy = resolveImage("", "", EMBED_ICONS.save, "krypton_ico_save_v4.png")
IconAssets.pencil = resolveImage("", "", EMBED_ICONS.pencil, "krypton_ico_pencil_v4.png")
IconAssets.trash = resolveImage("", "", EMBED_ICONS.trash, "krypton_ico_trash_v4.png")
IconAssets.plus = resolveImage("", "", EMBED_ICONS.plus, "krypton_ico_plus_v4.png")
IconAssets.eraser = resolveImage("", "", EMBED_ICONS.eraser, "krypton_ico_eraser_v4.png")
IconAssets.gear = resolveImage("", "", EMBED_ICONS.gear, "krypton_ico_gear_v4.png")
IconAssets.check = resolveImage("", "", EMBED_ICONS.check, "krypton_ico_check_v4.png")

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
		if not parent or not parent.Parent then conn:Disconnect() return end
		t = t + (dt)
		for _, p in ipairs(ps) do
			p.y = p.y - (p.v * dt)
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
-- SQUELETTE PARTAGÉ (ESP & Aperçu)
---------------------------------------------------------------------
local SKELETON_BONES = {
	{ "Head", "Neck" }, { "Neck", "Chest" }, { "Chest", "Pelvis" },
	{ "Neck", "L_Shoulder" }, { "Neck", "R_Shoulder" },
	{ "L_Shoulder", "L_Elbow" }, { "L_Elbow", "L_Hand" }, { "L_Hand", "L_Tip" },
	{ "R_Shoulder", "R_Elbow" }, { "R_Elbow", "R_Hand" }, { "R_Hand", "R_Tip" },
	{ "Pelvis", "L_Hip" }, { "L_Hip", "L_Knee" }, { "L_Knee", "L_Foot" }, { "L_Foot", "L_Toe" },
	{ "Pelvis", "R_Hip" }, { "R_Hip", "R_Knee" }, { "R_Knee", "R_Foot" }, { "R_Foot", "R_Toe" },
}

local function mkBone(parent, col)
	local shadow = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, BorderSizePixel = 0, Visible = false, ZIndex = 1 }, parent)
	corner(shadow, 0.5)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false, ZIndex = 2 }, parent)
	corner(f, 0.5)
	return f, shadow
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

local function motorPos(model, name)
	local m = model:FindFirstChild(name, true)
	if m and m:IsA("Motor6D") and m.Part0 then return (m.Part0.CFrame * m.C0).Position end
	return nil
end

local function partPos(model, name)
	local p = model:FindFirstChild(name, true)
	if p and p:IsA("BasePart") then return p.Position end
	return nil
end

local function partBottom(model, name)
	local p = model:FindFirstChild(name, true)
	if p and p:IsA("BasePart") then return (p.CFrame * CFrame.new(0, -p.Size.Y / 2, 0)).Position end
	return nil
end

local function getSkeletonPoints(model)
	local points = {}
	local head = model:FindFirstChild("Head")
	if head then points["Head"] = head.Position end
	local upperTorso = model:FindFirstChild("UpperTorso")
	local lowerTorso = model:FindFirstChild("LowerTorso")
	local torso = model:FindFirstChild("Torso")

	if upperTorso then
		points["Chest"] = upperTorso.Position
		points["Pelvis"] = lowerTorso and lowerTorso.Position or (upperTorso.Position - Vector3.new(0, 1, 0))
		points["Neck"] = motorPos(model, "Neck") or (upperTorso.Position + Vector3.new(0, upperTorso.Size.Y / 2, 0))
		for _, side in ipairs({ { "Left", "L" }, { "Right", "R" } }) do
			local sd, k = side[1], side[2]
			points[k .. "_Shoulder"] = motorPos(model, sd .. "Shoulder") or partPos(model, sd .. "UpperArm")
			points[k .. "_Elbow"] = motorPos(model, sd .. "Elbow") or partPos(model, sd .. "LowerArm")
			points[k .. "_Hand"] = motorPos(model, sd .. "Wrist") or partPos(model, sd .. "Hand")
			points[k .. "_Tip"] = partBottom(model, sd .. "Hand")
			points[k .. "_Hip"] = motorPos(model, sd .. "Hip") or partPos(model, sd .. "UpperLeg")
			points[k .. "_Knee"] = motorPos(model, sd .. "Knee") or partPos(model, sd .. "LowerLeg")
			points[k .. "_Foot"] = motorPos(model, sd .. "Ankle") or partPos(model, sd .. "Foot")
			points[k .. "_Toe"] = partBottom(model, sd .. "Foot")
		end
	elseif torso then
		local tcf, tsz = torso.CFrame, torso.Size
		points["Neck"] = (tcf * CFrame.new(0, tsz.Y / 2, 0)).Position
		points["Chest"] = tcf.Position
		points["Pelvis"] = (tcf * CFrame.new(0, -tsz.Y / 2, 0)).Position
		points["L_Shoulder"] = (tcf * CFrame.new(-tsz.X / 2, tsz.Y / 2 - 0.5, 0)).Position
		points["R_Shoulder"] = (tcf * CFrame.new(tsz.X / 2, tsz.Y / 2 - 0.5, 0)).Position
		points["L_Hip"] = (tcf * CFrame.new(-tsz.X / 4, -tsz.Y / 2, 0)).Position
		points["R_Hip"] = (tcf * CFrame.new(tsz.X / 4, -tsz.Y / 2, 0)).Position
		for _, side in ipairs({ { "Left", "L" }, { "Right", "R" } }) do
			local k = side[2]
			local arm = model:FindFirstChild(side[1] .. " Arm")
			local leg = model:FindFirstChild(side[1] .. " Leg")
			if arm and points[k .. "_Shoulder"] then
				local hand = (arm.CFrame * CFrame.new(0, -arm.Size.Y / 2, 0)).Position
				points[k .. "_Hand"] = hand
				points[k .. "_Tip"] = hand - Vector3.new(0, 0.4, 0)
				points[k .. "_Elbow"] = (points[k .. "_Shoulder"] + hand) / 2
			end
			if leg and points[k .. "_Hip"] then
				local foot = (leg.CFrame * CFrame.new(0, -leg.Size.Y / 2, 0)).Position
				points[k .. "_Foot"] = foot
				points[k .. "_Knee"] = (points[k .. "_Hip"] + foot) / 2
			end
		end
	end
	return points
end

---------------------------------------------------------------------
-- ICONES & PICTOGRAMMES
---------------------------------------------------------------------
local Icons = {}

function Icons.lock(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 4.5, 0.5, 9, 10, 4.5, color, 1.6)
	corner(new("Frame", { Position = UDim2.fromOffset(2, 8), Size = UDim2.fromOffset(14, 9), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 2)
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
		corner(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size * 1.35, 2), Rotation = rot, BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 1)
	end
	return h
end

function Icons.check(parent, color)
	local h = holder(parent, 0, 0, 18, 18)
	h.Size = UDim2.fromScale(1, 1)
	corner(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(6.5, 10), Size = UDim2.fromOffset(6, 2),
		Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0,
	}, h), 1)
	corner(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(10.5, 8), Size = UDim2.fromOffset(10, 2),
		Rotation = -50, BackgroundColor3 = color, BorderSizePixel = 0,
	}, h), 1)
	return h
end

local function tintIcon(h, col)
	for _, d in ipairs(h:GetDescendants()) do
		if d:IsA("UIStroke") then tween(d, 0.15, { Color = col })
		elseif d:IsA("ImageLabel") then tween(d, 0.15, { ImageColor3 = col })
		elseif d:IsA("Frame") and d.BackgroundTransparency < 1 and not d:GetAttribute("Hole") then
			tween(d, 0.15, { BackgroundColor3 = col })
		end
	end
end

function Icons.eye(parent, x, y, color, slashed)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 0, 4, 18, 10, 5, color, 1.6)
	ring(h, 6, 6, 6, 6, 3, color, 1.5)
	corner(new("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(2, 2), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 1)
	if slashed then
		corner(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(22, 2),
			Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 1)
	end
	return h
end

local function makeAssetIcon(assetKey)
	return function(parent, color)
		local h = holder(parent, 0, 0, 20, 20)
		h.AnchorPoint = Vector2.new(0.5, 0.5)
		h.Position = UDim2.fromScale(0.5, 0.5)
		local asset = IconAssets[assetKey]
		if asset then
			new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Image = asset, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit }, h)
		end
		return h
	end
end

Icons.download = makeAssetIcon("download")
Icons.floppy = makeAssetIcon("floppy")
Icons.pencil = makeAssetIcon("pencil")
Icons.trash = makeAssetIcon("trash")
Icons.plus = makeAssetIcon("plus")
Icons.eraser = makeAssetIcon("eraser")
do
	local fallbackCheck = Icons.check
	local checkAsset = makeAssetIcon("check")
	Icons.checkImg = function(parent, color)
		if not IconAssets.check then return fallbackCheck(parent, color) end
		return checkAsset(parent, color)
	end
end

---------------------------------------------------------------------
-- ICONES DU MENU
---------------------------------------------------------------------
local ACCENT = Color3.fromRGB(255, 255, 255)
local CAT_FONT = Enum.Font.Jura

local function fillDot(parent, x, y, s, color, isHole)
	local f = new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(s, s),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, parent)
	corner(f, s)
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
		corner(new("Frame", { Position = UDim2.fromOffset(bx, by), Size = UDim2.fromOffset(bw, bh), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 1)
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
	corner(new("Frame", { Position = UDim2.fromOffset(1.5, 10), Size = UDim2.fromOffset(15, 15), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 7.5)
	return h
end

function Icons.hubFarm(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 2, 2, 14, 14, 4, color, 1.5)
	corner(new("Frame", { Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(4, 8), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 2)
	corner(new("Frame", { Position = UDim2.fromOffset(4, 11), Size = UDim2.fromOffset(10, 3), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 1)
	return h
end

function Icons.hubGear(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	fillDot(h, 3.3, 3.3, 11.4, color)
	for k = 0, 7 do
		local a = k * math.pi / 4
		corner(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(9 + math.cos(a) * 7, 9 + math.sin(a) * 7),
			Size = UDim2.fromOffset(3.6, 4.2), Rotation = k * 45 + 90,
			BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 1)
	end
	fillDot(h, 6.6, 6.6, 4.8, holeCol, true)
	return h
end

function Icons.hubPalette(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	corner(new("Frame", { Position = UDim2.fromOffset(0.3, 1.3), Size = UDim2.fromOffset(17.4, 15.4), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 7.5)
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
	corner(screen, 3)
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
			corner(new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(22, 2),
				Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0,
			}, h), 1)
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
		TextColor3 = Color3.fromRGB(40, 40, 45), Rotation = -4,
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
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(210, 210, 220)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 150)),
		}),
	}, main)
	new("UIStroke", { Color = Color3.fromRGB(5, 5, 8), Thickness = 2 }, main)
	return h
end

---------------------------------------------------------------------
-- SYSTÈMES & EXPIRATION
---------------------------------------------------------------------
local function isLifetimeVal(e)
	if e == nil or e == "Lifetime" then return true end
	if type(e) == "number" and e > 4102444800 then return true end
	return false
end

local function expiresText(e)
	if isLifetimeVal(e) then return S("lifetime") end
	if type(e) == "number" then return os.date("%d/%m/%Y", e) end
	return tostring(e)
end

local RUBY_THEME = { c0 = Color3.fromRGB(235, 25, 65), c1 = Color3.fromRGB(255, 150, 170), spark = Color3.fromRGB(255, 255, 255) }
local PURPLE_THEME = { c0 = Color3.fromRGB(170, 80, 255), c1 = Color3.fromRGB(225, 185, 255), spark = Color3.fromRGB(255, 255, 255) }

local function rankTheme(rk)
	rk = string.lower(tostring(rk or ""))
	if rk == "free" then
		return { c0 = Color3.fromRGB(100, 190, 255), c1 = Color3.fromRGB(220, 245, 255), spark = Color3.fromRGB(255, 255, 255) }
	elseif rk == "standard" then
		return { c0 = Color3.fromRGB(100, 245, 150), c1 = Color3.fromRGB(215, 255, 230), spark = Color3.fromRGB(255, 255, 255) }
	elseif string.find(rk, "dev", 1, true) then
		return RUBY_THEME
	elseif string.find(rk, "creator", 1, true) or string.find(rk, "content", 1, true) then
		return PURPLE_THEME
	end
	return { c0 = Color3.fromRGB(255, 215, 80), c1 = Color3.fromRGB(255, 250, 200), spark = Color3.fromRGB(255, 255, 255) }
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
	local st = new("UIStroke", { Color = theme.c0:Lerp(Color3.new(0, 0, 0), 0.5), Thickness = 1.2, Transparency = 1 }, lbl)
	task.spawn(function()
		repeat task.wait(0.1) until not lbl or not lbl.Parent or lbl.TextTransparency < 0.9
		while lbl and lbl.Parent do
			grad.Offset = Vector2.new(-1, 0)
			tween(grad, 1.2, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(st, 0.6, { Transparency = 0.05 }, Enum.EasingStyle.Sine)
			task.wait(0.6)
			tween(st, 0.6, { Transparency = 0.35 }, Enum.EasingStyle.Sine)
			task.wait(1.6)
		end
	end)
end

local function makeExpiry(parent, pos, width, h, textSize)
	local root = new("Frame", { Position = pos, Size = UDim2.fromOffset(width, h), BackgroundTransparency = 1 }, parent)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }, root)
	local pre = new("TextLabel", { LayoutOrder = 1, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h), Text = "", Font = Enum.Font.Gotham, TextSize = textSize, TextColor3 = C.muted }, root)
	local val = new("TextLabel", { LayoutOrder = 2, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h), Text = "", Font = Enum.Font.GothamBlack, TextSize = textSize, TextColor3 = Color3.new(1, 1, 1) }, root)
	local grad = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 230)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(245, 245, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(245, 245, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 230)),
		}),
		Offset = Vector2.new(-1, 0),
	}, val)
	local st = new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.4 }, val)
	local self = { root = root }
	local W = Color3.new(1, 1, 1)
	local whiteSeq = grad.Color
	local rubySeq = ColorSequence.new({
		ColorSequenceKeypoint.new(0, RUBY_THEME.c0),
		ColorSequenceKeypoint.new(0.3, RUBY_THEME.c1),
		ColorSequenceKeypoint.new(0.45, W),
		ColorSequenceKeypoint.new(0.55, W),
		ColorSequenceKeypoint.new(0.7, RUBY_THEME.c1),
		ColorSequenceKeypoint.new(1, RUBY_THEME.c0),
	})
	function self.set(prefixText, e)
		pre.Text = prefixText or ""
		val.Text = expiresText(e)
		if isLifetimeVal(e) then
			grad.Color = rubySeq
			st.Color = RUBY_THEME.c0:Lerp(Color3.new(0, 0, 0), 0.35)
		else
			grad.Color = whiteSeq
			st.Color = Color3.fromRGB(255, 255, 255)
		end
	end
	task.spawn(function()
		while root and root.Parent do
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

local function deviceId()
	local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
	if ok and type(id) == "string" and id ~= "" then return id end
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
			Headers = { ["Content-Type"] = "application/json", ["Accept"] = "application/json" },
			Body = HttpService:JSONEncode(payload),
		})
		if ok and type(res) == "table" then
			local body = res.Body or res.body
			local code = tonumber(res.StatusCode or res.status_code or res.Status or res.status) or 0
			lastCode = code
			if type(body) == "string" and body ~= "" then
				local dok, dec = pcall(function() return HttpService:JSONDecode(body) end)
				if dok and type(dec) == "table" then return dec, code end
			end
			if code == 429 then return { error = "rate" }, code end
		end
		if attempt < tries then task.wait(delaySec) end
	end
	return nil, lastCode
end

local function resetHwid(username)
	if not globalRequest or not username or username == "" then return false end
	local data = httpJson("/api/hwid-reset", {
		username = username,
		password = Session.password or "",
		hwid = deviceId(),
	}, 3, 4)
	if type(data) == "table" then return data.ok == true or data.success == true end
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
stroke(window, C.stroke, 1, 0.2)

local scale = new("UIScale", {}, window)
local function updateScale()
	local v = gui.AbsoluteSize
	scale.Scale = math.clamp(math.min(v.X / 800, v.Y / 600), 0.4, 1)
end
updateScale()
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

---------------------------------------------------------------------
-- SYSTÈME ESP UNIVERSEL & SQUELETTE
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
local ESP_SKEL = Color3.fromRGB(180, 230, 255)

local function mkFrame(parent, col)
	return new("Frame", { BackgroundColor3 = col, BorderSizePixel = 0, Visible = false }, parent)
end
local function mkLine(parent, col)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false }, parent)
	corner(f, 1)
	stroke(f, Color3.fromRGB(5, 5, 10), 1.2, 0.3)
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
	if d.headCircle then d.headCircle.Visible = false end
end

local function createEsp(plr)
	local folder = new("Folder", { Name = plr.Name }, espGui)
	local d = { folder = folder, all = {}, bones = {}, boneShadows = {} }
	local function add(o)
		d.all[#d.all + 1] = o
		return o
	end
	d.box = add(new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false }, folder))
	stroke(d.box, ESP_WHITE, 1.5)
	d.snap = add(mkLine(folder, ESP_WHITE))
	d.name = add(mkText(folder, 13, ESP_WHITE, Enum.Font.GothamBold))
	d.dist = add(mkText(folder, 11, Color3.fromRGB(220, 220, 230), Enum.Font.GothamMedium))
	d.dist.ZIndex = 3
	local distBg = add(new("Frame", { BackgroundColor3 = Color3.fromRGB(10, 10, 14), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Visible = false }, folder))
	corner(distBg, 3)
	d.distBg = distBg
	d.weapon = add(mkText(folder, 11, Color3.fromRGB(255, 230, 180), Enum.Font.GothamMedium))
	d.weapon.ZIndex = 3
	local weapBg = add(new("Frame", { BackgroundColor3 = Color3.fromRGB(10, 10, 14), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Visible = false }, folder))
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
	d.headCircle = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10),
		BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
	}, folder)
	corner(d.headCircle, 100)
	stroke(d.headCircle, ESP_SKEL, 1.5)
	for i = 1, #SKELETON_BONES do
		local b, sh = mkBone(folder, ESP_SKEL)
		d.bones[i] = add(b)
		d.boneShadows[i] = add(sh)
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
	
	local dist = root and (cam.CFrame.Position - root.Position).Magnitude or 0
	if not (V.enable and root and hum and hum.Health > 0 and dist <= V.maxDistance) then
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
	if V.boxes then
		d.box.Position = UDim2.fromOffset(x0, y0)
		d.box.Size = UDim2.fromOffset(w, h)
		d.box.Visible = true
	else
		d.box.Visible = false
	end
	if V.snaplines then
		if V.snapPos == "Top" then setLine(d.snap, vs.X / 2, 0, cx, y0, 1.2)
		else setLine(d.snap, vs.X / 2, vs.Y, cx, y1, 1.2) end
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
		by = by + (16)
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
	local headPart = char:FindFirstChild("Head")
	if V.skeleton and headPart then
		local headScreenPos, headOn = cam:WorldToViewportPoint(headPart.Position)
		local thV = cam:WorldToViewportPoint(headPart.Position + Vector3.new(0, headPart.Size.Y / 2, 0))
		local bhV = cam:WorldToViewportPoint(headPart.Position - Vector3.new(0, headPart.Size.Y / 2, 0))
		-- Diamètre proportionnel à la distance : hauteur projetée de la tête, plafonné à 45% de la largeur de la boîte
		local headDiam = math.min(math.abs(bhV.Y - thV.Y), w * 0.45)
		if headOn and headScreenPos.Z > 0 and headDiam >= 2 then
			d.headCircle.Position = UDim2.fromOffset(headScreenPos.X, headScreenPos.Y)
			d.headCircle.Size = UDim2.fromOffset(headDiam, headDiam)
			d.headCircle.Visible = true
		else
			d.headCircle.Visible = false
		end
		local points = getSkeletonPoints(char)
		local skelTh = math.clamp(2.2 - dist / 150, 1.4, 2.2)
		local shown = {}
		for name, pos in pairs(points) do
			local wp, ok = cam:WorldToViewportPoint(pos)
			shown[name] = { pos = Vector2.new(wp.X, wp.Y), visible = ok and wp.Z > 0 }
		end
		for i = 1, #d.bones do
			local ln = d.bones[i]
			local sh = d.boneShadows[i]
			local boneData = SKELETON_BONES[i]
			local j1 = boneData and shown[boneData[1]]
			local j2 = boneData and shown[boneData[2]]
			if j1 and j2 and j1.visible and j2.visible then
				setBoneLine(ln, sh, j1.pos.X, j1.pos.Y, j2.pos.X, j2.pos.Y, skelTh)
			else
				ln.Visible = false
				if sh then sh.Visible = false end
			end
		end
	else
		if d.headCircle then d.headCircle.Visible = false end
		for i = 1, #d.bones do
			d.bones[i].Visible = false
			if d.boneShadows[i] then d.boneShadows[i].Visible = false end
		end
	end
end

Players.PlayerRemoving:Connect(removeEsp)

---------------------------------------------------------------------
-- SYSTÈMES D'ALERTE ADMIN
---------------------------------------------------------------------
local adminAlertActive = false
local adminGuiContainer = nil
local adminLeavingState = false
local adminAlertTriggeredOnce = false

local function checkAdminAlert()
	if not Settings.Visuals.adminAlert then
		if adminGuiContainer then
			adminGuiContainer:Destroy()
			adminGuiContainer = nil
		end
		adminAlertActive = false
		adminLeavingState = false
		adminAlertTriggeredOnce = false
		return
	end
	
	if adminAlertTriggeredOnce then return end

	local targetAdminNames = { "Cmoirobloxien1jk" }
	local found = false
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			for _, adminName in ipairs(targetAdminNames) do
				if p.Name == adminName or p.DisplayName == adminName then
					found = true
					break
				end
			end
		end
		if found then break end
	end
	
	if found then
		adminAlertTriggeredOnce = true
		adminLeavingState = false
		if not adminAlertActive then
			adminAlertActive = true
			if not adminGuiContainer then
				adminGuiContainer = new("ScreenGui", { Name = "KryptonAdminAlertPro", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999 }, pg)
				setupGuiProtection(adminGuiContainer)
			end
			
			local banner = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -140),
				Size = UDim2.fromOffset(460, 116), BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 999
			}, adminGuiContainer)
			corner(banner, 14)
			stroke(banner, C.stroke, 1.5, 0.1)
			
			new("UIGradient", {
				Rotation = 0,
				Color = ColorSequence.new(C.bg, Color3.fromRGB(22, 22, 28)),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0),
				}),
			}, banner)
			
			local bannerLogo = makeLogo(banner, 28, UDim2.fromOffset(14, 14))
			bannerLogo.ZIndex = 1000

			local alertCloseBtn = new("TextButton", {
				Position = UDim2.fromOffset(418, 12), Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1,
				Text = "", AutoButtonColor = false, ZIndex = 1005,
			}, banner)
			local alertCloseX = Icons.cross(alertCloseBtn, 14, 14, 11, C.muted)
			local function tintAlertX(col)
				for _, f in ipairs(alertCloseX:GetChildren()) do
					if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = col }) end
				end
			end
			alertCloseBtn.MouseEnter:Connect(function() tintAlertX(C.text); tween(alertCloseX, 0.3, { Rotation = 90 }, Enum.EasingStyle.Back) end)
			alertCloseBtn.MouseLeave:Connect(function() tintAlertX(C.muted); tween(alertCloseX, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back) end)
			alertCloseBtn.MouseButton1Click:Connect(function()
				tween(banner, 0.3, { Position = UDim2.new(0.5, 0, 0, -140) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
				task.wait(0.32)
				if adminGuiContainer then
					adminGuiContainer:Destroy()
					adminGuiContainer = nil
				end
				adminAlertActive = false
			end)
			
			local titleHolder = new("Frame", {
				Position = UDim2.fromOffset(50, 14), Size = UDim2.fromOffset(350, 20), BackgroundTransparency = 1, ZIndex = 1000
			}, banner)
			
			local greenDot = new("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.good, BorderSizePixel = 0, ZIndex = 1000
			}, titleHolder)
			corner(greenDot, 4)
			
			task.spawn(function()
				while greenDot and greenDot.Parent do
					tween(greenDot, 0.8, { BackgroundTransparency = 0.5 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
					task.wait(0.8)
					tween(greenDot, 0.8, { BackgroundTransparency = 0 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
					task.wait(0.8)
				end
			end)

			local adminTitleLbl = label(titleHolder, S("adminAlertTitle"), 13, UDim2.fromOffset(16, 0), UDim2.fromOffset(330, 20), C.text, CAT_FONT)

			local adminDescLbl = label(banner, string.format(S("adminAlertDesc"), 5), 11, UDim2.fromOffset(50, 36), UDim2.fromOffset(360, 20), C.muted, Enum.Font.GothamMedium)

			local safeBtn = new("TextButton", {
				Position = UDim2.fromOffset(16, 68), Size = UDim2.fromOffset(428, 38),
				BackgroundColor3 = C.field, Text = "", AutoButtonColor = false, ZIndex = 1000
			}, banner)
			corner(safeBtn, 8)
			local safeSt = stroke(safeBtn, C.stroke, 1)
			
			local shieldIcon = holder(safeBtn, 12, 10, 18, 18)
			ring(shieldIcon, 4.5, 0.5, 9, 10, 4.5, C.text, 1.6)
			corner(new("Frame", { Position = UDim2.fromOffset(2, 8), Size = UDim2.fromOffset(14, 9), BackgroundColor3 = C.text, BorderSizePixel = 0 }, shieldIcon), 2)
			for _, d in ipairs(shieldIcon:GetDescendants()) do if d:IsA("GuiObject") then d.ZIndex = 1001 end end

			local safeLbl = label(safeBtn, "Désactiver le cheat", 11, UDim2.fromOffset(36, 4), UDim2.fromOffset(380, 16), C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
			safeLbl.ZIndex = 1001

			local safeSubLbl = label(safeBtn, S("adminAlertOptDesc"), 9, UDim2.fromOffset(36, 20), UDim2.fromOffset(380, 14), C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Left)
			safeSubLbl.ZIndex = 1001

			local function executeDeactivation()
				Settings.Visuals.enable = false
				Settings.Visuals.boxes = false
				Settings.Visuals.snaplines = false
				Settings.Visuals.skeleton = false
				Settings.Visuals.names = false
				Settings.Visuals.distance = false
				Settings.Visuals.health = false
				Settings.Visuals.armor = false
				Settings.Visuals.weapon = false
				Settings.Visuals.count = false

				safeLbl.Text = S("adminAlertDescDone")
				safeLbl.TextColor3 = C.good
				safeLbl.Size = UDim2.fromOffset(380, 30)
				safeSubLbl.Visible = false
				shieldIcon.Visible = false
				tween(safeBtn, 0.2, { BackgroundColor3 = Color3.fromRGB(28, 54, 36) })
				tween(safeSt, 0.2, { Color = C.good })
				adminDescLbl.Text = S("adminAlertDescDone")
			end

			task.spawn(function()
				for i = 5, 1, -1 do
					if not banner or not banner.Parent or not adminAlertActive then return end
					adminDescLbl.Text = string.format(S("adminAlertDesc"), i)
					task.wait(1)
				end
				if banner and banner.Parent and adminAlertActive then
					executeDeactivation()
				end
			end)

			safeBtn.MouseEnter:Connect(function()
				tween(safeBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) })
				tween(safeSt, 0.15, { Color = Color3.fromRGB(120, 120, 140) })
			end)
			safeBtn.MouseLeave:Connect(function()
				tween(safeBtn, 0.15, { BackgroundColor3 = C.field })
				tween(safeSt, 0.15, { Color = C.stroke })
			end)
			safeBtn.MouseButton1Click:Connect(function()
				executeDeactivation()
			end)

			tween(banner, 0.55, { Position = UDim2.new(0.5, 0, 0, 18) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		end
	else
		if adminAlertActive and not adminLeavingState then
			adminLeavingState = true
			adminAlertActive = false
			if adminGuiContainer then
				for _, ch in ipairs(adminGuiContainer:GetChildren()) do
					if ch:IsA("Frame") then
						ch.BackgroundColor3 = C.panel
						local st = ch:FindFirstChildOfClass("UIStroke")
						if st then st.Color = C.good end
						for _, lbl in ipairs(ch:GetChildren()) do
							if lbl:IsA("TextLabel") and lbl.TextSize == 13 then
								lbl.TextColor3 = C.good
								lbl.Text = "ADMIN PARTI — SÉCURISÉ"
							elseif lbl:IsA("TextLabel") and lbl.TextSize == 11 then
								lbl.Visible = false
							elseif lbl:IsA("TextButton") then
								lbl.Visible = false
							end
						end
						tween(ch, 0.4, { Position = UDim2.new(0.5, 0, 0, -120) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
					end
				end
				task.delay(4, function()
					if adminGuiContainer and adminLeavingState then
						adminGuiContainer:Destroy()
						adminGuiContainer = nil
						adminLeavingState = false
					end
				end)
			end
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function() checkAdminAlert() end)
	checkAdminAlert()
end)

Players.PlayerRemoving:Connect(function(p) checkAdminAlert() end)

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
	
	checkAdminAlert()

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
	BackgroundColor3 = Color3.fromRGB(18, 18, 23), BorderSizePixel = 0,
}, window)
corner(right, 14)
new("UIGradient", {
	Rotation = 0,
	Color = ColorSequence.new(C.bg, Color3.fromRGB(22, 22, 28)),
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
	stroke(f, Color3.fromRGB(60, 60, 75), 1, transp)
	return f
end
local c1 = circle(138, 0.5)
local c2 = circle(85, 0.65)

task.spawn(function()
	while right and right.Parent do
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
	while right and right.Parent do
		local r = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
			Size = UDim2.fromOffset(80, 80), BackgroundTransparency = 1,
		}, right)
		new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, r)
		local s = stroke(r, Color3.fromRGB(220, 220, 235), 1.5, 0.35)
		tween(r, 2.6, { Size = UDim2.fromOffset(276, 276) })
		tween(s, 2.6, { Transparency = 1 })
		task.wait(1.4)
	end
end)

local dot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = Color3.fromRGB(240, 240, 255), BorderSizePixel = 0,
}, right)
corner(dot, 3)
new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.5, Thickness = 3 }, dot)

local dot2 = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(4, 4),
	BackgroundColor3 = Color3.fromRGB(180, 180, 195), BorderSizePixel = 0,
}, right)
corner(dot2, 2)
new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.6, Thickness = 2 }, dot2)

local angle = math.rad(100)
local sweepConn
sweepConn = RunService.RenderStepped:Connect(function(dt)
	if not right or not right.Parent then sweepConn:Disconnect() return end
	angle = angle + (dt * 0.7)
	dot.Position = UDim2.fromOffset(CENTER.X + math.cos(angle) * 138, CENTER.Y + math.sin(angle) * 138)
	dot2.Position = UDim2.fromOffset(CENTER.X + math.cos(-angle * 1.6 + 2) * 85, CENTER.Y + math.sin(-angle * 1.6 + 2) * 85)
	sweepGrad.Rotation = (sweepGrad.Rotation + dt * 80) % 360
end)

local glow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
	Size = UDim2.fromOffset(180, 180), BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0.94, BorderSizePixel = 0,
}, right)
new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, glow)
task.spawn(function()
	while right and right.Parent do
		tween(glow, 1.6, { BackgroundTransparency = 0.88, Size = UDim2.fromOffset(205, 205) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1.6)
		tween(glow, 1.6, { BackgroundTransparency = 0.96, Size = UDim2.fromOffset(170, 170) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1.6)
	end
end)

local bigLogo = makeLogo(right, 130, UDim2.fromOffset(CENTER.X, CENTER.Y), Vector2.new(0.5, 0.5))

task.spawn(function()
	local t = 0
	while right and right.Parent do
		t = t + (task.wait())
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
	b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) }) end)
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
	Position = UDim2.fromOffset(0, 56), Size = UDim2.fromOffset(300, 36), BackgroundColor3 = C.panel,
}, leftContainer)
corner(tabContainer, 8)
stroke(tabContainer, C.stroke, 1)

local tabPill = new("Frame", {
	Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(144, 30), BackgroundColor3 = C.field,
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
		tween(st, 0.15, { Color = Color3.fromRGB(120, 120, 140), Thickness = 1.6 })
		tween(f, 0.15, { BackgroundColor3 = Color3.fromRGB(34, 34, 44) })
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
	BackgroundColor3 = C.field, BorderSizePixel = 0,
}, rememberBtn)
corner(rBox, 5)
local rStroke = stroke(rBox, C.stroke, 1)
local rMark = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
}, rBox)
Icons.check(rMark, C.text)
local rMarkScale = new("UIScale", { Scale = 1 }, rMark)
local rememberLbl = label(rememberBtn, "", 12, UDim2.fromOffset(34, 0), UDim2.fromOffset(250, 24), Color3.fromRGB(210, 210, 220), Enum.Font.Gotham)

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
rememberBtn.MouseLeave:Connect(function() tween(rememberLbl, 0.15, { TextColor3 = Color3.fromRGB(210, 210, 220) }) end)

local status = label(leftContainer, "", 11, UDim2.fromOffset(0, Y_STATUS), UDim2.fromOffset(300, 16), C.err, Enum.Font.GothamMedium)

local submit = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_SUBMIT), Size = UDim2.fromOffset(300, 42), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
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
	while submit and submit.Parent do
		shine.Position = UDim2.fromOffset(-60, -14)
		tween(shine, 0.9, { Position = UDim2.fromOffset(340, -14) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(4)
	end
end)

submit.MouseEnter:Connect(function() tween(submit, 0.15, { BackgroundColor3 = Color3.fromRGB(230, 230, 240) }) end)
submit.MouseLeave:Connect(function()
	tween(submit, 0.15, { BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.fromOffset(300, 42), Position = UDim2.fromOffset(0, Y_SUBMIT) })
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
	while badge and badge.Parent do
		local r = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 14),
			Size = UDim2.fromOffset(8, 8), BackgroundTransparency = 1,
		}, badge)
		new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, r)
		local s = stroke(r, badgeDot.BackgroundColor3, 1.5, 0.2)
		tween(r, 1.2, { Size = UDim2.fromOffset(22, 22) })
		tween(s, 1.2, { Transparency = 1 })
		task.delay(1.3, function() if r then r:Destroy() end end)
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
-- KRYPTON HUB PRINCIPAL
---------------------------------------------------------------------
local refreshAdminUI = function() end

local function openHub(username, rank, expires, expiresAt)
	Authed = true
	local hub = new("Frame", {
		Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 50,
	}, gui)
	corner(hub, 14)
	local hubStroke = stroke(hub, C.stroke, 1, 0.2)
	
	local toastFrame = new("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromOffset(600, 8), Size = UDim2.fromOffset(220, 36),
		BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 70, Visible = false,
	}, hub)
	corner(toastFrame, 8)
	stroke(toastFrame, C.stroke, 1)
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
		toastToken = toastToken + (1)
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

	-- Échelle du hub (adaptée à l'écran) + multiplicateur choisi par l'utilisateur via le triangle de redimensionnement
	local hs = new("UIScale", {}, hub)
	local userMult = 1
	local function baseScale()
		local v = gui.AbsoluteSize
		return math.clamp(math.min(v.X / 720, v.Y / 480), 0.4, 1)
	end
	local function us()
		local v = gui.AbsoluteSize
		local base = baseScale()
		local maxS = math.max(base, math.min(v.X / 660, v.Y / 420))
		hs.Scale = math.clamp(base * userMult, 0.4, maxS)
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
		while hub and hub.Parent do
			t = t + (task.wait())
			hubLogo.Rotation = math.sin(t * 1.6) * 4
		end
	end)

	-- Triangle de redimensionnement (coin bas droit du hub)
	do
		local rzHolder = new("Frame", {
			Position = UDim2.fromOffset(640 - 22, 400 - 22), Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 60,
		}, hub)
		rzHolder:SetAttribute("NoTheme", true)
		local rzTri = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(16, 16),
			Size = UDim2.fromOffset(21.2, 21.2), Rotation = 45,
			BackgroundColor3 = C.muted, BorderSizePixel = 0, ZIndex = 61,
		}, rzHolder)
		rzTri:SetAttribute("NoTheme", true)
		local rzBtn = new("TextButton", {
			Position = UDim2.fromOffset(640 - 32, 400 - 32), Size = UDim2.fromOffset(32, 32),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 65,
		}, hub)
		rzBtn.MouseEnter:Connect(function() tween(rzTri, 0.15, { BackgroundColor3 = C.text }) end)
		rzBtn.MouseLeave:Connect(function() tween(rzTri, 0.15, { BackgroundColor3 = C.muted }) end)
		local resizing, rzStartMouse, rzStartScale = false, nil, 1
		rzBtn.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				resizing = true
				rzStartMouse = i.Position
				rzStartScale = hs.Scale
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local dx = i.Position.X - rzStartMouse.X
				local dy = i.Position.Y - rzStartMouse.Y
				-- Le hub est centré : le coin bas droit se déplace de (W/2, H/2) par unité d'échelle
				local ds = (dx * 320 + dy * 200) / (320 * 320 + 200 * 200)
				local desired = rzStartScale + ds
				userMult = math.clamp(desired / baseScale(), 0.6, 1.6)
				us()
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				resizing = false
			end
		end)
	end

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
	local TXT_OFF = Color3.fromRGB(150, 150, 162)
	local TXT_HOVER = Color3.fromRGB(220, 220, 235)
	local side = new("Frame", { Position = UDim2.fromOffset(14, 66), Size = UDim2.fromOffset(150, 280), BackgroundTransparency = 1 }, hub)
	local pill = new("Frame", { Size = UDim2.fromOffset(150, 36), BackgroundColor3 = C.panel, BorderSizePixel = 0 }, side)
	corner(pill, 6)
	local pillStroke = stroke(pill, C.stroke, 1)
	local pillBar = new("Frame", { Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(3, 26), BackgroundColor3 = ACCENT, BorderSizePixel = 0 }, pill)
	corner(pillBar, 2)
	task.spawn(function()
		while hub and hub.Parent do
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
		local ico = catDef.icon(pgC, 0, 0, Color3.fromRGB(90, 90, 100), C.bg)
		ico.AnchorPoint = Vector2.new(0.5, 0.5)
		ico.Position = UDim2.fromOffset(223, 104)
		new("UIScale", { Scale = 2.6 }, ico)
		reg(label(pgC, "", 22, UDim2.fromOffset(0, 156), UDim2.fromOffset(446, 28), C.text, CAT_FONT, Enum.TextXAlignment.Center), catKey)
		reg(label(pgC, "", 12, UDim2.fromOffset(0, 184), UDim2.fromOffset(446, 18), C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Center), "comingSoonTitle")
		task.spawn(function()
			while ico and ico.Parent do
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
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, parent)
		corner(subBar, 8)
		stroke(subBar, C.stroke, 1)
		local subPill = new("Frame", {
			Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(SUB_W, 24),
			BackgroundColor3 = C.field, BorderSizePixel = 0, ZIndex = 1,
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

	-- FONCTION D'APPLICATION DES THÈMES DE COULEURS SUR LE HUB
	local updateThemeUI = function() end
	local function applyTheme(key)
		local t = Themes[key]
		if not t then return end
		currentThemeKey = key
		ACCENT = t.accent
		C.stroke = t.stroke
		C.field = t.field
		pillBar.BackgroundColor3 = ACCENT
		hubStroke.Color = ACCENT
		updateThemeUI()
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
		btn.MouseEnter:Connect(function() if not busy and not armed then tween(btn, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) }) end end)
		btn.MouseLeave:Connect(function() if not busy and not armed then tween(btn, 0.15, { BackgroundColor3 = C.field }) end end)
		btn.MouseButton1Click:Connect(function()
			if busy then return end
			if not armed then
				armed = true
				btn.Text = S("resetConfirm")
				tween(btn, 0.15, { BackgroundColor3 = Color3.fromRGB(58, 30, 30) })
				tween(btnSt, 0.15, { Color = C.err })
				task.delay(3, function() if armed and not busy then armed = false; idle() end end)
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

		-- Liste des profils : source de vérité en mémoire, synchronisée avec le fichier (si l'executor le permet)
		local profileCounter = 0
		local function newProfileId()
			profileCounter = profileCounter + (1)
			return tostring(os.time()) .. "_" .. tostring(profileCounter) .. "_" .. tostring(math.random(1000, 9999))
		end
		local function copyVisuals(srcT)
			local out = {}
			for k, v in pairs(srcT) do
				local tv = type(v)
				if tv == "boolean" or tv == "number" or tv == "string" then out[k] = v end
			end
			return out
		end
		local function loadProfilesFromFile()
			local list = {}
			if not (isfile and readfile and isfile(Config.ProfilesFile)) then return list end
			local ok, res = pcall(function() return HttpService:JSONDecode(readfile(Config.ProfilesFile)) end)
			if not (ok and type(res) == "table") then return list end
			local source = res.profiles
			if type(source) ~= "table" then
				-- ancien format : { ["1"] = {...}, ["2"] = {...} }
				source = {}
				local nums = {}
				for k, v in pairs(res) do
					if tonumber(k) and type(v) == "table" then nums[#nums + 1] = tonumber(k) end
				end
				table.sort(nums)
				for _, n in ipairs(nums) do
					local v = res[n] or res[tostring(n)]
					if type(v) == "table" then source[#source + 1] = { name = "Profile " .. n, data = v } end
				end
			end
			for _, p in ipairs(source) do
				if type(p) == "table" and type(p.data) == "table" then
					list[#list + 1] = {
						id = (type(p.id) == "string" and p.id ~= "") and p.id or newProfileId(),
						name = string.sub(tostring(p.name or "Profile"), 1, 20),
						data = p.data,
					}
				end
				if #list >= 10 then break end
			end
			return list
		end
		local profilesList = loadProfilesFromFile()
		local function saveProfilesToFile()
			if not writefile then return end
			pcall(function() writefile(Config.ProfilesFile, HttpService:JSONEncode({ profiles = profilesList })) end)
		end
		local loadedProfileId = nil
		local renderProfilesList
		local function updateHeader() profilesHeaderLbl.Text = string.format(S("profilesCount"), #profilesList) end
		onLang[#onLang + 1] = updateHeader

		-- Applique un profil : les clés absentes reviennent à leur valeur par défaut
		local function applyProfileData(data)
			local V = Settings.Visuals
			for k, cur in pairs(V) do
				local nv = data[k]
				if k == "snapPos" then
					V[k] = (nv == "Top" or nv == "Bottom") and nv or "Bottom"
				elseif k == "maxDistance" then
					V[k] = (type(nv) == "number") and math.clamp(math.floor(nv), 0, 1000) or 1000
				elseif type(cur) == "boolean" then
					V[k] = (nv == true)
				end
			end
			if refreshVisualsUI then refreshVisualsUI() end
		end

		local profScroll = new("ScrollingFrame", {
			Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(446, 212),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(90, 90, 100), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
		}, pProf)
		new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }, profScroll)

		local ICON_REST = Color3.fromRGB(150, 150, 162)
		local TRASH_REST = Color3.fromRGB(224, 112, 112)
		local TRASH_HOVER = Color3.fromRGB(255, 70, 70)

		local addBtn = new("TextButton", {
			Position = UDim2.fromOffset(418, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		}, pProf)
		local addIconObj = Icons.plus(addBtn, ICON_REST)
		addBtn.MouseEnter:Connect(function() tintIcon(addIconObj, C.text) end)
		addBtn.MouseLeave:Connect(function() tintIcon(addIconObj, ICON_REST) end)
		addBtn.MouseButton1Click:Connect(function()
			if #profilesList >= 10 then return end
			local prof = { id = newProfileId(), name = S("newProfileName"), data = copyVisuals(Settings.Visuals) }
			profilesList[#profilesList + 1] = prof
			loadedProfileId = prof.id
			saveProfilesToFile()
			renderProfilesList()
			task.defer(function() profScroll.CanvasPosition = Vector2.new(0, 100000) end)
			showToast(prof.name, S("toastCreated"))
		end)

		local eraseBtn = new("TextButton", {
			Position = UDim2.fromOffset(384, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		}, pProf)
		local eraseIconObj = Icons.eraser(eraseBtn, ICON_REST)
		eraseBtn.MouseEnter:Connect(function() tintIcon(eraseIconObj, C.text) end)
		eraseBtn.MouseLeave:Connect(function() tintIcon(eraseIconObj, ICON_REST) end)
		eraseBtn.MouseButton1Click:Connect(function()
			local V = Settings.Visuals
			for k, v in pairs(V) do
				if type(v) == "boolean" then V[k] = false end
			end
			V.snapPos = "Bottom"
			V.maxDistance = 1000
			local title = S("settingsTitle")
			for _, p in ipairs(profilesList) do
				if p.id == loadedProfileId then title = p.name end
			end
			loadedProfileId = nil
			if refreshVisualsUI then refreshVisualsUI() end
			renderProfilesList()
			showToast(title, S("toastReset"))
		end)

		renderProfilesList = function()
			for _, ch in ipairs(profScroll:GetChildren()) do
				if ch:IsA("Frame") then ch:Destroy() end
			end
			updateHeader()
			for idx, prof in ipairs(profilesList) do
				local isLoaded = (loadedProfileId == prof.id)
				local row = new("Frame", {
					Size = UDim2.fromOffset(440, 40), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = idx,
				}, profScroll)
				corner(row, 8)
				stroke(row, C.stroke, 1)
				local nameLbl = label(row, prof.name, 12, UDim2.fromOffset(12, 0), UDim2.fromOffset(270, 40), isLoaded and C.text or Color3.fromRGB(190, 190, 202), Enum.Font.GothamMedium)
				nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
				local function actionButton(x, iconFn, rest, hover, cb)
					local btn = new("TextButton", {
						Position = UDim2.fromOffset(x, 6), Size = UDim2.fromOffset(28, 28),
						BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
					}, row)
					local ico = iconFn(btn, rest)
					btn.MouseEnter:Connect(function() tintIcon(ico, hover) end)
					btn.MouseLeave:Connect(function() tintIcon(ico, rest) end)
					btn.MouseButton1Click:Connect(cb)
					return btn, ico
				end

				-- Charger (masqué pour le profil actuellement chargé)
				if not isLoaded then
					actionButton(296, Icons.download, ICON_REST, C.text, function()
						applyProfileData(prof.data)
						loadedProfileId = prof.id
						renderProfilesList()
						showToast(prof.name, S("toastLoaded"))
					end)
				end

				-- Sauvegarder les réglages actuels dans ce profil
				actionButton(326, Icons.floppy, ICON_REST, C.text, function()
					prof.data = copyVisuals(Settings.Visuals)
					loadedProfileId = prof.id
					saveProfilesToFile()
					renderProfilesList()
					showToast(prof.name, S("toastSaved"))
				end)

				-- Renommer
				local renameBtn = new("TextButton", {
					Position = UDim2.fromOffset(356, 6), Size = UDim2.fromOffset(28, 28),
					BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
				}, row)
				local renameIco = Icons.pencil(renameBtn, ICON_REST)
				local isRenaming = false
				local renameBox
				renameBtn.MouseEnter:Connect(function() if not isRenaming then tintIcon(renameIco, C.text) end end)
				renameBtn.MouseLeave:Connect(function() if not isRenaming then tintIcon(renameIco, ICON_REST) end end)
				local function finishRename()
					if not isRenaming then return end
					isRenaming = false
					local newN = string.gsub(renameBox.Text, "^%s+", "")
					newN = string.gsub(newN, "%s+$", "")
					if newN ~= "" then
						prof.name = string.sub(newN, 1, 20)
						saveProfilesToFile()
					end
					renderProfilesList()
					showToast(prof.name, S("toastRenamed"))
				end
				renameBtn.MouseButton1Click:Connect(function()
					if isRenaming then
						finishRename()
						return
					end
					isRenaming = true
					nameLbl.Visible = false
					for _, ch in ipairs(renameBtn:GetChildren()) do ch:Destroy() end
					Icons.checkImg(renameBtn, C.good)
					renameBox = new("TextBox", {
						Position = UDim2.fromOffset(12, 6), Size = UDim2.fromOffset(270, 28),
						BackgroundTransparency = 1, Text = prof.name, TextColor3 = C.text,
						Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false,
					}, row)
					renameBox:GetPropertyChangedSignal("Text"):Connect(function()
						if #renameBox.Text > 20 then renameBox.Text = string.sub(renameBox.Text, 1, 20) end
					end)
					renameBox.FocusLost:Connect(function() finishRename() end)
					renameBox:CaptureFocus()
				end)

				-- Supprimer
				actionButton(386, Icons.trash, TRASH_REST, TRASH_HOVER, function()
					if loadedProfileId == prof.id then loadedProfileId = nil end
					table.remove(profilesList, idx)
					saveProfilesToFile()
					renderProfilesList()
					showToast(prof.name, S("toastDeleted"))
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
			b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) }) end)
			b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = C.field }) end)
			b.MouseButton1Click:Connect(function()
				currentLang = code
				saveLang()
				applyLang()
			end)
		end
		onLang[#onLang + 1] = function()
			local onFR = ("FR" == currentLang)
			local onEN = ("EN" == currentLang)
			langRefs["FR"].b.TextColor3 = onFR and C.text or C.muted
			tween(langRefs["FR"].st, 0.2, { Color = onFR and C.text or C.stroke })
			langRefs["EN"].b.TextColor3 = onEN and C.text or C.muted
			tween(langRefs["EN"].st, 0.2, { Color = onEN and C.text or C.stroke })
		end
	end

	-- Style du K flottant (rempli après la création de kFloat, plus bas dans openHub)
	local applyKLogoStyle = function(style) end

	-- PAGE PERSONNALISER (CAT CUSTOMIZE) : sous-catégories "Menu" (palette, Rainbow) et "Logo" (Change Logo)
	local function customPage()
		local pgCustom = new("Frame", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgCustom
		reg(label(pgCustom, "", 20, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 28), C.text, CAT_FONT), "catCustom")

		-- Sous-catégories (même principe que Général / Avancé dans Visuels)
		local subPagesC = {}
		makeSubTabs(pgCustom, { "subMenu", "subLogo" }, function(idx)
			for i, p in ipairs(subPagesC) do p.Visible = (i == idx) end
		end)
		local function newSubScroll(visible)
			return new("ScrollingFrame", {
				Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242),
				BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
				ScrollBarImageColor3 = Color3.fromRGB(90, 90, 100), AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = visible,
			}, pgCustom)
		end
		local menuScroll = newSubScroll(true)
		local logoScroll = newSubScroll(false)
		subPagesC[1] = menuScroll
		subPagesC[2] = logoScroll
		new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }, logoScroll)

		---------------------------------------------------------------
		-- PALETTE DE COULEURS / RAINBOW / LOGO PREMIUM
		---------------------------------------------------------------
		local Palette = { applied = nil, rainbowESP = false, rainbowMenu = false }
		local DEFAULT_ESP_SKEL = Color3.fromRGB(180, 230, 255)
		local DEFAULT_ESP_MAIN = Color3.new(1, 1, 1)
		local rankKey = string.lower(tostring(rank or "standard"))
		local isPremiumRank = (rankKey ~= "free" and rankKey ~= "standard" and rankKey ~= "")
		local selfPainters = {}
		local menuCache, skelCache, skelScanned = {}, {}, false
		local lastMenuCol = ACCENT
		hubLogo:SetAttribute("NoTheme", true)

		local function colorClose(a, b, tol)
			tol = tol or 0.02
			return math.abs(a.R - b.R) < tol and math.abs(a.G - b.G) < tol and math.abs(a.B - b.B) < tol
		end
		local function toHex(c)
			return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
		end
		local function themable(d)
			local a = d.Parent
			while a and a ~= hub do
				if a:GetAttribute("NoTheme") then return false end
				a = a.Parent
			end
			return true
		end
		-- Repère tous les éléments du hub qui ont la couleur recherchée
		local function scanColor(matchFn)
			local out = {}
			for _, d in ipairs(hub:GetDescendants()) do
				local prop
				if d:IsA("Frame") then
					if d.BackgroundTransparency < 1 and not d:FindFirstChildOfClass("UIGradient") and matchFn(d.BackgroundColor3) then
						prop = "BackgroundColor3"
					end
				elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
					if d.ImageTransparency < 1 and d.Image ~= LogoAsset and matchFn(d.ImageColor3) then
						prop = "ImageColor3"
					end
				elseif d:IsA("UIStroke") then
					local p = d.Parent
					if p and not (p:IsA("TextLabel") or p:IsA("TextButton") or p:IsA("TextBox")) and matchFn(d.Color) then
						prop = "Color"
					end
				end
				if prop and themable(d) then out[#out + 1] = { inst = d, prop = prop } end
			end
			return out
		end
		local function paintList(list, col, instant)
			for i = #list, 1, -1 do
				local e = list[i]
				if e.inst and e.inst.Parent then
					if instant then e.inst[e.prop] = col else tween(e.inst, 0.35, { [e.prop] = col }) end
				else
					table.remove(list, i)
				end
			end
		end

		-- Couleur du menu (boutons, cases, icônes, contour...)
		local function paintMenu(col, instant, rescan)
			if rescan then
				local prevA, prevL = ACCENT, lastMenuCol
				menuCache = scanColor(function(c) return colorClose(c, prevA) or colorClose(c, prevL) end)
			end
			ACCENT = col
			lastMenuCol = col
			paintList(menuCache, col, instant)
			if instant then
				pillBar.BackgroundColor3 = col
				hubStroke.Color = col
			else
				tween(pillBar, 0.35, { BackgroundColor3 = col })
				tween(hubStroke, 0.35, { Color = col })
			end
			for _, f in ipairs(selfPainters) do f(col) end
		end

		-- Couleur de l'ESP (squelette, boîtes, lignes, noms) + aperçu
		local function paintSkelPreview(col)
			if not skelScanned then
				skelScanned = true
				skelCache = scanColor(function(c) return colorClose(c, DEFAULT_ESP_SKEL) end)
			end
			paintList(skelCache, col, true)
		end
		local function setEspColor(skelCol, mainCol)
			ESP_SKEL = skelCol
			ESP_WHITE = mainCol
			for _, d in pairs(espObjs) do
				local bs = d.box and d.box:FindFirstChildOfClass("UIStroke")
				if bs then bs.Color = mainCol end
				if d.snap then d.snap.BackgroundColor3 = mainCol end
				if d.name then d.name.TextColor3 = mainCol end
				if d.headCircle then
					local hs = d.headCircle:FindFirstChildOfClass("UIStroke")
					if hs then hs.Color = skelCol end
				end
				if d.bones then
					for i = 1, #d.bones do d.bones[i].BackgroundColor3 = skelCol end
				end
			end
			paintSkelPreview(skelCol)
		end
		local function restoreEsp()
			if Palette.applied then setEspColor(Palette.applied, Palette.applied)
			else setEspColor(DEFAULT_ESP_SKEL, DEFAULT_ESP_MAIN) end
		end
		local function restoreMenu()
			paintMenu(Palette.applied or Themes[currentThemeKey].accent, false, false)
			if refreshVisualsUI then refreshVisualsUI() end
		end

		-- Conteneur persistant de la sous-catégorie "Menu"
		local palContainer = new("Frame", {
			Size = UDim2.fromOffset(440, 0), AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 0,
		}, menuScroll)
		palContainer:SetAttribute("Persist", true)
		new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }, palContainer)

		---------------------------------------------------------------
		-- 1) PALETTE (Teinte / Saturation / Luminosité) + Apply Changes
		---------------------------------------------------------------
		local CARD_BASE_H, CARD_OPEN_H = 168, 218
		local palCard = new("Frame", {
			Size = UDim2.fromOffset(440, CARD_BASE_H), BackgroundColor3 = C.panel, BorderSizePixel = 0,
			ClipsDescendants = true, LayoutOrder = 1,
		}, palContainer)
		corner(palCard, 8)
		stroke(palCard, C.stroke, 1)
		reg(label(palCard, "", 12, UDim2.fromOffset(12, 6), UDim2.fromOffset(416, 18), C.text, Enum.Font.GothamBold), "customPaletteTitle")
		reg(label(palCard, "", 10, UDim2.fromOffset(12, 25), UDim2.fromOffset(416, 16), C.muted, Enum.Font.Gotham), "customPaletteDesc")

		local selH, selS, selV = Color3.toHSV(ACCENT)
		local function selColor() return Color3.fromHSV(selH, selS, selV) end
		local updateSel

		-- Sélecteur de couleur : carré saturation / luminosité + barre de teinte verticale
		local PK_X, PK_Y, PK_W, PK_H = 12, 46, 254, 110
		local HB_X = PK_X + PK_W + 10
		local pickerHolder = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, palCard)
		pickerHolder:SetAttribute("NoTheme", true)
		local svBase = new("Frame", {
			Position = UDim2.fromOffset(PK_X, PK_Y), Size = UDim2.fromOffset(PK_W, PK_H),
			BackgroundColor3 = Color3.fromHSV(selH, 1, 1), BorderSizePixel = 0,
		}, pickerHolder)
		corner(svBase, 8)
		local svWhite = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, svBase)
		corner(svWhite, 8)
		new("UIGradient", { Transparency = NumberSequence.new(0, 1) }, svWhite)
		local svBlack = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0 }, svBase)
		corner(svBlack, 8)
		new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }, svBlack)
		local svCursor = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14),
			BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6,
		}, pickerHolder)
		corner(svCursor, 7)
		stroke(svCursor, Color3.new(1, 1, 1), 2)

		local hueBar = new("Frame", {
			Position = UDim2.fromOffset(HB_X, PK_Y), Size = UDim2.fromOffset(16, PK_H),
			BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, pickerHolder)
		corner(hueBar, 6)
		do
			local keys = {}
			for i = 0, 6 do keys[#keys + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i % 6) / 6, 1, 1)) end
			new("UIGradient", { Rotation = 90, Color = ColorSequence.new(keys) }, hueBar)
		end
		local function hueMarker()
			return new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(7, 7), Rotation = 45,
				BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 6,
			}, pickerHolder)
		end
		local hueL, hueR = hueMarker(), hueMarker()

		local function bindDrag(btn, onPos)
			local dragging = false
			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					menuScroll.ScrollingEnabled = false
					onPos(input)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					onPos(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					dragging = false
					menuScroll.ScrollingEnabled = true
				end
			end)
		end
		local svBtn = new("TextButton", {
			Position = UDim2.fromOffset(PK_X - 6, PK_Y - 6), Size = UDim2.fromOffset(PK_W + 12, PK_H + 12),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
		}, pickerHolder)
		bindDrag(svBtn, function(input)
			selS = math.clamp((input.Position.X - svBase.AbsolutePosition.X) / svBase.AbsoluteSize.X, 0, 1)
			selV = 1 - math.clamp((input.Position.Y - svBase.AbsolutePosition.Y) / svBase.AbsoluteSize.Y, 0, 1)
			updateSel()
		end)
		local hueBtn = new("TextButton", {
			Position = UDim2.fromOffset(HB_X - 8, PK_Y - 6), Size = UDim2.fromOffset(32, PK_H + 12),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
		}, pickerHolder)
		bindDrag(hueBtn, function(input)
			selH = math.min(math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1), 0.999)
			updateSel()
		end)

		local prevSwatch = new("Frame", {
			Position = UDim2.fromOffset(HB_X + 28, PK_Y), Size = UDim2.fromOffset(124, 36),
			BackgroundColor3 = selColor(), BorderSizePixel = 0,
		}, palCard)
		prevSwatch:SetAttribute("NoTheme", true)
		corner(prevSwatch, 8)
		stroke(prevSwatch, C.stroke, 1)
		local rgbLbl = label(palCard, "", 11, UDim2.fromOffset(HB_X + 28, PK_Y + 44), UDim2.fromOffset(124, 16), C.text, Enum.Font.GothamBold)
		local hexLbl = label(palCard, "", 11, UDim2.fromOffset(HB_X + 28, PK_Y + 62), UDim2.fromOffset(124, 16), C.muted, Enum.Font.GothamMedium)

		-- Menu déroulant "Apply Changes"
		local applyPanel = new("Frame", {
			Position = UDim2.fromOffset(12, 174), Size = UDim2.fromOffset(416, 0),
			BackgroundTransparency = 1, ClipsDescendants = true, Visible = false,
		}, palCard)
		local applyBtn2 = new("TextButton", {
			Size = UDim2.fromOffset(416, 36), BackgroundColor3 = C.field, Text = "", AutoButtonColor = false,
		}, applyPanel)
		corner(applyBtn2, 8)
		local applySt = stroke(applyBtn2, C.stroke, 1)
		local applyDot = new("Frame", {
			Position = UDim2.fromOffset(12, 11), Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = selColor(), BorderSizePixel = 0,
		}, applyBtn2)
		applyDot:SetAttribute("NoTheme", true)
		corner(applyDot, 7)
		stroke(applyDot, Color3.new(1, 1, 1), 1, 0.3)
		reg(label(applyBtn2, "", 12, UDim2.fromOffset(36, 0), UDim2.fromOffset(330, 36), C.text, Enum.Font.GothamBold), "applyChanges")
		local chev = holder(applyBtn2, 388, 11, 14, 14)
		for _, rot in ipairs({ 40, -40 }) do
			corner(new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(rot > 0 and 4.2 or 9.8, 7),
				Size = UDim2.fromOffset(7, 1.8), Rotation = rot, BackgroundColor3 = C.muted, BorderSizePixel = 0,
			}, chev), 1)
		end
		applyBtn2.MouseEnter:Connect(function()
			tween(applyBtn2, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) })
			tween(applySt, 0.15, { Color = Color3.fromRGB(120, 120, 140) })
		end)
		applyBtn2.MouseLeave:Connect(function()
			tween(applyBtn2, 0.15, { BackgroundColor3 = C.field })
			tween(applySt, 0.15, { Color = C.stroke })
		end)

		local applyShown = false
		local function showApply(on)
			if on == applyShown then return end
			applyShown = on
			if on then applyPanel.Visible = true end
			tween(palCard, 0.3, { Size = UDim2.fromOffset(440, on and CARD_OPEN_H or CARD_BASE_H) }, Enum.EasingStyle.Quint)
			tween(applyPanel, 0.3, { Size = UDim2.fromOffset(416, on and 36 or 0) }, Enum.EasingStyle.Quint)
			tween(chev, 0.3, { Rotation = on and 180 or 0 })
			if not on then
				task.delay(0.32, function() if not applyShown then applyPanel.Visible = false end end)
			end
		end

		updateSel = function()
			local col = selColor()
			svBase.BackgroundColor3 = Color3.fromHSV(selH, 1, 1)
			svCursor.Position = UDim2.fromOffset(PK_X + selS * PK_W, PK_Y + (1 - selV) * PK_H)
			hueL.Position = UDim2.fromOffset(HB_X - 3, PK_Y + selH * PK_H)
			hueR.Position = UDim2.fromOffset(HB_X + 19, PK_Y + selH * PK_H)
			prevSwatch.BackgroundColor3 = col
			applyDot.BackgroundColor3 = col
			rgbLbl.Text = string.format("RGB  %d, %d, %d", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
			hexLbl.Text = toHex(col)
			showApply(not colorClose(col, Palette.applied or lastMenuCol, 0.004))
		end

		applyBtn2.MouseButton1Click:Connect(function()
			local col = selColor()
			Palette.applied = col
			if not Palette.rainbowMenu then
				paintMenu(col, false, true)
				if refreshVisualsUI then refreshVisualsUI() end
			end
			if not Palette.rainbowESP then setEspColor(col, col) end
			showToast(toHex(col), S("toastApplied"))
			updateSel()
		end)
		updateSel()

		---------------------------------------------------------------
		-- 2) RAINBOW ESP / RAINBOW MENU
		---------------------------------------------------------------
		local function toggleRow(order, key, onChange)
			local row = new("Frame", {
				Size = UDim2.fromOffset(440, 40), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = order,
			}, palContainer)
			corner(row, 8)
			stroke(row, C.stroke, 1)
			reg(label(row, "", 12, UDim2.fromOffset(12, 0), UDim2.fromOffset(300, 40), C.text, Enum.Font.GothamMedium), key)
			local cb = new("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(1, -34, 0.5, 0),
				Size = UDim2.fromOffset(22, 22), BackgroundColor3 = C.field, BorderSizePixel = 0,
			}, row)
			corner(cb, 6)
			local cbSt = stroke(cb, C.stroke, 1)
			local mark = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
			}, cb)
			Icons.check(mark, C.bg)
			local markScale = new("UIScale", { Scale = 0 }, mark)
			local on = false
			selfPainters[#selfPainters + 1] = function(col)
				if on then cb.BackgroundColor3 = col; cbSt.Color = col end
			end
			local btn = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, row)
			btn.MouseButton1Click:Connect(function()
				on = not on
				tween(cb, 0.18, { BackgroundColor3 = on and ACCENT or C.field })
				tween(cbSt, 0.18, { Color = on and ACCENT or C.stroke })
				tween(markScale, 0.22, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
				onChange(on)
			end)
		end

		toggleRow(2, "rainbowEsp", function(on)
			Palette.rainbowESP = on
			if not on then restoreEsp() end
		end)
		toggleRow(3, "rainbowMenu", function(on)
			Palette.rainbowMenu = on
			if on then
				paintMenu(Color3.fromHSV((os.clock() * 0.12) % 1, 0.85, 1), true, true)
			else
				restoreMenu()
			end
		end)

		local rbLast, rbRefresh = 0, 0
		local rbConn
		rbConn = RunService.RenderStepped:Connect(function()
			if not hub or not hub.Parent then rbConn:Disconnect() return end
			if not (Palette.rainbowESP or Palette.rainbowMenu) then return end
			local now = os.clock()
			if now - rbLast < 0.04 then return end
			rbLast = now
			local col = Color3.fromHSV((now * 0.12) % 1, 0.85, 1)
			if Palette.rainbowESP then setEspColor(col, col) end
			if Palette.rainbowMenu then
				paintMenu(col, true, false)
				if now - rbRefresh > 0.5 then
					rbRefresh = now
					if refreshVisualsUI then refreshVisualsUI() end
				end
			end
		end)

		---------------------------------------------------------------
		-- 3) CHANGER LE LOGO (réservé Premium) - sous-catégorie "Logo"
		---------------------------------------------------------------
		local LogoStyles = {
			{ key = "logoOriginal" },
			{ key = "logoGold", base = Color3.fromRGB(255, 200, 40), light = Color3.fromRGB(255, 240, 170) },
			{ key = "logoSilver", base = Color3.fromRGB(190, 195, 210), light = Color3.fromRGB(245, 248, 255) },
			{ key = "logoRuby", base = Color3.fromRGB(225, 30, 60), light = Color3.fromRGB(255, 150, 165) },
			{ key = "logoSapphire", base = Color3.fromRGB(40, 100, 255), light = Color3.fromRGB(150, 190, 255) },
			{ key = "logoEmerald", base = Color3.fromRGB(30, 200, 120), light = Color3.fromRGB(150, 255, 200) },
			{ key = "logoAmethyst", base = Color3.fromRGB(160, 70, 240), light = Color3.fromRGB(215, 170, 255) },
			{ key = "logoNeon", base = Color3.fromRGB(255, 40, 150), light = Color3.fromRGB(255, 160, 215) },
			{ key = "logoIce", base = Color3.fromRGB(70, 210, 255), light = Color3.fromRGB(190, 245, 255) },
		}
		local logoOrig, logoShine = {}, {}
		local function logoSequence(st)
			local W = Color3.new(1, 1, 1)
			return ColorSequence.new({
				ColorSequenceKeypoint.new(0, st.base),
				ColorSequenceKeypoint.new(0.3, st.light),
				ColorSequenceKeypoint.new(0.45, W),
				ColorSequenceKeypoint.new(0.55, W),
				ColorSequenceKeypoint.new(0.7, st.light),
				ColorSequenceKeypoint.new(1, st.base),
			})
		end
		local function styleLogo(h, st)
			local target = h:FindFirstChildOfClass("ImageLabel")
			if not target then
				for _, ch in ipairs(h:GetChildren()) do
					if ch:IsA("TextLabel") and ch:FindFirstChildOfClass("UIGradient") then target = ch end
				end
			end
			if not target then return end
			local grad = target:FindFirstChildOfClass("UIGradient")
			if st.base then
				if not grad then
					grad = new("UIGradient", {}, target)
					grad.Name = "KLogoGrad"
				end
				if not logoOrig[grad] then logoOrig[grad] = { c = grad.Color, r = grad.Rotation, created = (grad.Name == "KLogoGrad") } end
				grad.Color = logoSequence(st)
				grad.Rotation = 20
				logoShine[grad] = true
			elseif grad and logoOrig[grad] then
				local o = logoOrig[grad]
				logoShine[grad] = nil
				if o.created then
					logoOrig[grad] = nil
					grad:Destroy()
				else
					grad.Color = o.c
					grad.Rotation = o.r
					grad.Offset = Vector2.new(0, 0)
				end
			end
		end
		task.spawn(function()
			while hub and hub.Parent do
				for g in pairs(logoShine) do
					if g.Parent then
						g.Offset = Vector2.new(-1, 0)
						tween(g, 1.2, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
					else
						logoShine[g] = nil
					end
				end
				task.wait(2.6)
			end
		end)

		-- Bannière d'erreur (logo en haut à gauche + "Premium Members" brillant)
		local logoErr = new("CanvasGroup", {
			Position = UDim2.fromOffset(0, 50), Size = UDim2.fromOffset(446, 44),
			BackgroundColor3 = Color3.fromRGB(20, 20, 26), BorderSizePixel = 0,
			GroupTransparency = 1, Visible = false, ZIndex = 40,
		}, pgCustom)
		corner(logoErr, 12)
		stroke(logoErr, C.stroke, 1)
		local errLogo = makeLogo(logoErr, 30, UDim2.fromOffset(10, 7))
		errLogo:SetAttribute("NoTheme", true)
		local errRow = new("Frame", { Position = UDim2.fromOffset(48, 0), Size = UDim2.fromOffset(388, 44), BackgroundTransparency = 1 }, logoErr)
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4),
		}, errRow)
		new("TextLabel", {
			LayoutOrder = 1, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 44),
			Text = "This Feature is only for", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text,
		}, errRow)
		local errPremium = new("TextLabel", {
			LayoutOrder = 2, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 44),
			Text = "Premium Members", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1, 1, 1),
		}, errRow)
		applyRankShine(errPremium, rankTheme("premium"))

		local logoErrToken = 0
		local function showPremiumError()
			logoErrToken = logoErrToken + (1)
			local tok = logoErrToken
			logoErr.Visible = true
			logoErr.Position = UDim2.fromOffset(0, 50)
			tween(logoErr, 0.35, { Position = UDim2.fromOffset(0, 68), GroupTransparency = 0 }, Enum.EasingStyle.Back)
			task.delay(3.2, function()
				if logoErrToken ~= tok then return end
				tween(logoErr, 0.25, { Position = UDim2.fromOffset(0, 50), GroupTransparency = 1 })
				task.wait(0.28)
				if logoErrToken == tok then logoErr.Visible = false end
			end)
		end

		-- Carte "Change Logo" avec menu déroulant
		local LOGO_HEAD_H = 56
		local LOGO_LIST_H = 5 * 40 - 6
		local LOGO_OPEN_H = LOGO_HEAD_H + 8 + LOGO_LIST_H + 10
		local logoCard = new("Frame", {
			Size = UDim2.fromOffset(440, LOGO_HEAD_H), BackgroundColor3 = C.panel, BorderSizePixel = 0,
			ClipsDescendants = true, LayoutOrder = 1,
		}, logoScroll)
		corner(logoCard, 8)
		stroke(logoCard, C.stroke, 1)
		reg(label(logoCard, "", 12, UDim2.fromOffset(12, 9), UDim2.fromOffset(230, 18), C.text, Enum.Font.GothamBold), "changeLogo")
		reg(label(logoCard, "", 10, UDim2.fromOffset(12, 29), UDim2.fromOffset(230, 16), C.muted, Enum.Font.Gotham), "changeLogoDesc")

		local ddBtn = new("TextButton", {
			Position = UDim2.fromOffset(246, 12), Size = UDim2.fromOffset(182, 32),
			BackgroundColor3 = C.field, Text = "", AutoButtonColor = false,
		}, logoCard)
		corner(ddBtn, 8)
		local ddSt = stroke(ddBtn, C.stroke, 1)
		local ddLogo = makeLogo(ddBtn, 22, UDim2.fromOffset(8, 5))
		ddLogo:SetAttribute("NoTheme", true)
		local ddName = label(ddBtn, "", 11, UDim2.fromOffset(38, 0), UDim2.fromOffset(112, 32), C.text, Enum.Font.GothamMedium)
		ddName.TextTruncate = Enum.TextTruncate.AtEnd
		local ddChev = holder(ddBtn, 158, 9, 14, 14)
		for _, rot in ipairs({ 40, -40 }) do
			corner(new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(rot > 0 and 4.2 or 9.8, 7),
				Size = UDim2.fromOffset(7, 1.8), Rotation = rot, BackgroundColor3 = C.muted, BorderSizePixel = 0,
			}, ddChev), 1)
		end
		ddBtn.MouseEnter:Connect(function() tween(ddSt, 0.15, { Color = Color3.fromRGB(120, 120, 140) }) end)
		ddBtn.MouseLeave:Connect(function() tween(ddSt, 0.15, { Color = C.stroke }) end)

		local logoList = new("Frame", {
			Position = UDim2.fromOffset(12, LOGO_HEAD_H + 8), Size = UDim2.fromOffset(416, LOGO_LIST_H), BackgroundTransparency = 1,
		}, logoCard)
		local currentLogo = LogoStyles[1]
		local logoCells = {}
		local function refreshLogoCells()
			for _, c in ipairs(logoCells) do
				local sel = (c.style == currentLogo)
				tween(c.st, 0.15, { Color = sel and ACCENT or C.stroke, Thickness = sel and 1.5 or 1 })
			end
			ddName.Text = S(currentLogo.key)
		end
		onLang[#onLang + 1] = function() ddName.Text = S(currentLogo.key) end
		selfPainters[#selfPainters + 1] = function(col)
			for _, c in ipairs(logoCells) do
				if c.style == currentLogo then c.st.Color = col end
			end
		end
		local logoOpen = false
		local function setLogoList(open)
			logoOpen = open
			tween(logoCard, 0.3, { Size = UDim2.fromOffset(440, open and LOGO_OPEN_H or LOGO_HEAD_H) }, Enum.EasingStyle.Quint)
			tween(ddChev, 0.3, { Rotation = open and 180 or 0 })
		end
		for i, st in ipairs(LogoStyles) do
			local colI, rowI = (i - 1) % 2, math.floor((i - 1) / 2)
			local cell = new("TextButton", {
				Position = UDim2.fromOffset(colI * 212, rowI * 40), Size = UDim2.fromOffset(204, 34),
				BackgroundColor3 = C.field, Text = "", AutoButtonColor = false,
			}, logoList)
			corner(cell, 8)
			local cst = stroke(cell, C.stroke, 1)
			local lg = makeLogo(cell, 24, UDim2.fromOffset(8, 5))
			lg:SetAttribute("NoTheme", true)
			styleLogo(lg, st)
			local nl = reg(label(cell, "", 12, UDim2.fromOffset(42, 0), UDim2.fromOffset(156, 34), C.text, Enum.Font.GothamMedium), st.key)
			nl.TextTruncate = Enum.TextTruncate.AtEnd
			logoCells[#logoCells + 1] = { style = st, st = cst }
			cell.MouseEnter:Connect(function() tween(cell, 0.15, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) }) end)
			cell.MouseLeave:Connect(function() tween(cell, 0.15, { BackgroundColor3 = C.field }) end)
			cell.MouseButton1Click:Connect(function()
				if not isPremiumRank then showPremiumError() return end
				currentLogo = st
				styleLogo(hubLogo, st)
				styleLogo(ddLogo, st)
				applyKLogoStyle(st)
				refreshLogoCells()
				showToast(S(st.key), S("toastApplied"))
				setLogoList(false)
			end)
		end
		refreshLogoCells()
		ddBtn.MouseButton1Click:Connect(function()
			if not isPremiumRank then
				showPremiumError()
				return
			end
			setLogoList(not logoOpen)
		end)
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
			Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = true,
		}, pgF)
		subPagesV[1] = pgGeneral
		local function card(parent, x, w, h)
			local f = new("Frame", {
				Position = UDim2.fromOffset(x, 0), Size = UDim2.fromOffset(w, h),
				BackgroundColor3 = C.panel, BorderSizePixel = 0, ClipsDescendants = true,
			}, parent)
			corner(f, 10)
			stroke(f, C.stroke, 1)
			return f
		end
		local setCard = card(pgGeneral, 0, 226, 242)
		local preCard = card(pgGeneral, 238, 208, 242)
		reg(label(setCard, "", 13, UDim2.fromOffset(14, 8), UDim2.fromOffset(160, 20), C.text, CAT_FONT), "settingsTitle")
		Icons.previewSymbol(preCard, 14, 11, ACCENT)
		reg(label(preCard, "", 13, UDim2.fromOffset(36, 8), UDim2.fromOffset(170, 20), C.text, CAT_FONT), "previewTitle")
		local opts = {
			{ "enable", "optEnable" }, { "boxes", "optBoxes" }, { "snaplines", "optSnaplines" },
			{ "skeleton", "optSkeleton" }, { "names", "optNames" }, { "distance", "optDistance" }, { "health", "optHealth" },
			{ "armor", "optArmor" }, { "weapon", "optWeapon" }, { "count", "optCount" },
		}
		local ROW_H = 32
		local scroll = new("ScrollingFrame", {
			Position = UDim2.fromOffset(0, 34), Size = UDim2.fromOffset(226, 202),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(90, 90, 100), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
		}, setCard)
		local BW, BH = 208, 208
		local body = new("Frame", {
			Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(BW, BH),
			BackgroundTransparency = 1, ClipsDescendants = true,
		}, preCard)
		local vp = new("ViewportFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
			Ambient = Color3.fromRGB(220, 220, 230), LightColor = Color3.fromRGB(255, 255, 255),
			LightDirection = Vector3.new(0.3, -0.5, -1),
		}, body)
		local function projectVF(cam, worldPos, W, H)
			local lp = cam.CFrame:PointToObjectSpace(worldPos)
			if lp.Z >= 0 then return 0, 0, false end
			local t = math.tan(math.rad(cam.FieldOfView / 2))
			local x = W / 2 + (lp.X / (-lp.Z * t)) * (H / 2)
			local y = H / 2 - (lp.Y / (-lp.Z * t)) * (H / 2)
			return x, y, true
		end
		local function buildModel()
			local model
			pcall(function()
				local desc = Players:GetHumanoidDescriptionFromUserId(player.UserId)
				if desc then model = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15) end
			end)
			if not model and player.Character then
				pcall(function()
					player.Character.Archivable = true
					model = player.Character:Clone()
					player.Character.Archivable = false
				end)
			end
			if model then
				for _, child in ipairs(model:GetChildren()) do
					if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Sound") or child:IsA("ForceField") or child:IsA("Tool") or child:IsA("BillboardGui") then
						child:Destroy()
					elseif child:IsA("Humanoid") then
						child.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						child.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
					end
				end
				local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
				if rootPart then
					local visited = {}
					local queue = { rootPart }
					visited[rootPart] = true
					while #queue > 0 do
						local current = table.remove(queue, 1)
						for _, desc in ipairs(model:GetDescendants()) do
							if (desc:IsA("Motor6D") or desc:IsA("Weld") or desc:IsA("WeldConstraint")) and desc.Part0 == current and desc.Part1 and not visited[desc.Part1] then
								local p0, p1 = desc.Part0, desc.Part1
								if desc:IsA("Motor6D") then
									desc.Transform = CFrame.new()
									p1.CFrame = p0.CFrame * desc.C0 * desc.C1:Inverse()
								elseif desc:IsA("Weld") then
									p1.CFrame = p0.CFrame * desc.C0 * desc.C1:Inverse()
								end
								visited[p1] = true
								table.insert(queue, p1)
							end
						end
					end
				end
				for _, acc in ipairs(model:GetChildren()) do
					if acc:IsA("Accessory") then
						local handle = acc:FindFirstChild("Handle")
						if handle then
							local attHandle = handle:FindFirstChildOfClass("Attachment")
							local head = model:FindFirstChild("Head")
							if attHandle and head then
								local attPerso = head:FindFirstChild(attHandle.Name) or model:FindFirstChild(attHandle.Name, true)
								if attPerso and attPerso:IsA("Attachment") then
									handle.CFrame = attPerso.Parent.CFrame * attPerso.CFrame * attHandle.CFrame:Inverse()
								end
							end
							if head and (handle.Position - head.Position).Magnitude > 6 then handle:Destroy() end
						end
					end
				end
				for _, d in ipairs(model:GetDescendants()) do if d:IsA("AnimationTrack") or d.Name == "Animate" then d:Destroy() end end
			end
			if not model then
				model = Instance.new("Model")
				local function part(name, size, pos, col)
					local p = Instance.new("Part")
					p.Name = name; p.Size = size; p.Position = pos; p.Color = col
					p.Material = Enum.Material.SmoothPlastic
					p.Parent = model
				end
				local skin = Color3.fromRGB(245, 205, 150)
				part("Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 4.9, 0), skin)
				part("UpperTorso", Vector3.new(2, 1.5, 1), Vector3.new(0, 3.5, 0), Color3.fromRGB(30, 30, 38))
				part("LowerTorso", Vector3.new(2, 0.8, 1), Vector3.new(0, 2.5, 0), Color3.fromRGB(40, 45, 65))
			end
			local primary = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
			if primary then model.PrimaryPart = primary end
			for _, d in ipairs(model:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false end end
			return model
		end
		local model = buildModel()
		model.Parent = vp
		model:PivotTo(CFrame.new(0, 0, 0))
		local cf, size = model:GetBoundingBox()
		local maxDim = math.max(size.X, size.Y, size.Z, 3)
		local dist = maxDim / (0.66 * 2 * math.tan(math.rad(20)))
		local cam = Instance.new("Camera")
		cam.FieldOfView = 40
		cam.CFrame = CFrame.lookAt(cf.Position + Vector3.new(0, 0, -dist), cf.Position)
		cam.Parent = vp
		vp.CurrentCamera = cam
		local function place(a) model:PivotTo(CFrame.new(cf.Position) * CFrame.Angles(0, a, 0)) end
		place(0)
		local BOXH = BH * 0.66
		local BOXW = BOXH * 0.6
		local CXb, CYb = BW / 2, BH / 2
		local bx0, by0 = CXb - BOXW / 2, CYb - BOXH / 2
		local bx1, by1 = bx0 + BOXW, by0 + BOXH
		local function group()
			return new("CanvasGroup", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, GroupTransparency = 1 }, body)
		end
		local gSnap, gSkel, gBox, gName, gHealth, gArmor, gWeapon, gCount, gDist =
			group(), group(), group(), group(), group(), group(), group(), group(), group()
		local snapCol = Color3.fromRGB(255, 255, 255)
		local snapItems = { Bottom = {}, Top = {} }
		snapItems.Bottom[1] = mkLine(gSnap, snapCol)
		setLine(snapItems.Bottom[1], BW / 2, BH, CXb, by1, 1.5)
		snapItems.Bottom[2] = fillDot(gSnap, CXb - 2.5, by1 - 2.5, 5, snapCol)
		snapItems.Top[1] = mkLine(gSnap, snapCol)
		setLine(snapItems.Top[1], BW / 2, 0, CXb, by0, 1.5)
		snapItems.Top[2] = fillDot(gSnap, CXb - 2.5, by0 - 2.5, 5, snapCol)
		local distLbl = new("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(CXb - 70, by1 + 6), Size = UDim2.fromOffset(140, 14),
			Text = "24m", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(220, 220, 230),
			TextStrokeTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 3,
		}, gDist)
		local distBgPrev = new("Frame", { BackgroundColor3 = Color3.fromRGB(10, 10, 14), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2 }, gDist)
		corner(distBgPrev, 3)
		local skelCol = Color3.fromRGB(180, 230, 255)
		local previewHeadCircle = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12),
			BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
		}, gSkel)
		corner(previewHeadCircle, 100)
		stroke(previewHeadCircle, skelCol, 1.5)
		local previewBones, previewBoneShadows = {}, {}
		for i = 1, #SKELETON_BONES do
			local b, sh = mkBone(gSkel, skelCol)
			previewBones[i] = b
			previewBoneShadows[i] = sh
		end
		local boxF = new("Frame", { Position = UDim2.fromOffset(bx0, by0), Size = UDim2.fromOffset(BOXW, BOXH), BackgroundTransparency = 1 }, gBox)
		stroke(boxF, Color3.new(1, 1, 1), 1.5)
		new("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(CXb - 70, by0 - 17), Size = UDim2.fromOffset(140, 14),
			Text = player.DisplayName, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text,
			TextStrokeTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Center,
		}, gName)
		local hBar = new("Frame", {
			Position = UDim2.fromOffset(bx0 - 7, by0), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.fromRGB(25, 25, 32), BorderSizePixel = 0,
		}, gHealth)
		local hClip = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, ClipsDescendants = true,
		}, hBar)
		local hFill = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, hClip)
		new("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 230, 110)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 210, 70)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 70, 70)),
			}),
		}, hFill)
		local hNum = new("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "100",
			Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(110, 231, 140), TextXAlignment = Enum.TextXAlignment.Right,
			TextStrokeTransparency = 0.5,
		}, gHealth)
		local aBar = new("Frame", {
			Position = UDim2.fromOffset(bx0 - 13, by0), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.fromRGB(25, 25, 32), BorderSizePixel = 0,
		}, gArmor)
		local aClip = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, ClipsDescendants = true,
		}, aBar)
		local aFill = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, aClip)
		new("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new(Color3.fromRGB(120, 190, 255), Color3.fromRGB(60, 100, 230)),
		}, aFill)
		local aNum = new("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "75",
			Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(130, 190, 255), TextXAlignment = Enum.TextXAlignment.Right,
			TextStrokeTransparency = 0.5,
		}, gArmor)
		local weaponLbl = new("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(CXb - 70, by1 + 6), Size = UDim2.fromOffset(140, 14),
			Text = "AK-47", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(255, 230, 180),
			TextStrokeTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 3,
		}, gWeapon)
		local weapBgPrev = new("Frame", { BackgroundColor3 = Color3.fromRGB(10, 10, 14), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2 }, gWeapon)
		corner(weapBgPrev, 3)
		local countBox = new("Frame", {
			Position = UDim2.new(0, 8, 1, -30), Size = UDim2.fromOffset(90, 22),
			BackgroundColor3 = C.bg, BackgroundTransparency = 0.15, BorderSizePixel = 0,
		}, gCount)
		corner(countBox, 6)
		stroke(countBox, C.stroke, 1)
		local countLbl = new("TextLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = Enum.Font.GothamMedium,
			TextSize = 11, TextColor3 = C.text, Text = "", TextXAlignment = Enum.TextXAlignment.Center,
		}, countBox)
		local function updateCount() countLbl.Text = S("playersLbl") .. ": " .. #Players:GetPlayers() end
		updateCount()
		onLang[#onLang + 1] = updateCount
		local groups = {
			boxes = gBox, snaplines = gSnap, skeleton = gSkel, names = gName, distance = gDist,
			health = gHealth, armor = gArmor, weapon = gWeapon, count = gCount,
		}
		local rows = {}
		local render
		render = function()
			for pos, items in pairs(snapItems) do
				for _, it in ipairs(items) do it.Visible = (V.snapPos == pos) end
			end
			for k, g in pairs(groups) do
				local on = V.enable and V[k]
				tween(g, 0.2, { GroupTransparency = on and 0 or 1 })
			end
			for k, r in pairs(rows) do
				r.set(V[k])
				if k ~= "enable" then tween(r.lbl, 0.15, { TextColor3 = V.enable and C.text or C.muted }) end
			end
		end
		local syncMaxDistUI = function() end
		refreshVisualsUI = function()
			render()
			if refreshDD then refreshDD() end
			if refreshAdminUI then refreshAdminUI() end
			syncMaxDistUI()
		end
		local BOX_OFF = Color3.fromRGB(22, 22, 28)
		local BOX_OFF_STROKE = Color3.fromRGB(45, 45, 58)
		for idx, o in ipairs(opts) do
			local k, tk = o[1], o[2]
			local row = new("Frame", {
				Position = UDim2.fromOffset(0, (idx - 1) * ROW_H + 2), Size = UDim2.fromOffset(226, ROW_H), BackgroundTransparency = 1,
			}, scroll)
			local cbox = new("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
				Size = UDim2.fromOffset(22, 22), BackgroundColor3 = BOX_OFF, BorderSizePixel = 0,
			}, row)
			corner(cbox, 6)
			local cboxSt = stroke(cbox, BOX_OFF_STROKE, 1)
			local mark = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
			}, cbox)
			Icons.check(mark, C.bg)
			local markScale = new("UIScale", { Scale = 0 }, mark)
			if k == "snaplines" then
				row.ZIndex = 20
				local ddBtn = new("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
					Size = UDim2.fromOffset(56, 22), BackgroundColor3 = C.field, Text = "",
					AutoButtonColor = false, ZIndex = 8,
				}, row)
				corner(ddBtn, 6)
				local ddSt = stroke(ddBtn, C.stroke, 1)
				local ddLbl = label(ddBtn, "", 10, UDim2.fromOffset(8, 0), UDim2.fromOffset(36, 22), C.text, Enum.Font.GothamMedium)
				ddLbl.ZIndex = 9
				for _, rot in ipairs({ 40, -40 }) do
					corner(new("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(rot > 0 and 44.2 or 47.8, 11.5),
						Size = UDim2.fromOffset(5, 1.6), Rotation = rot, BackgroundColor3 = C.muted,
						BorderSizePixel = 0, ZIndex = 9,
					}, ddBtn), 1)
				end
				local ddList = new("Frame", {
					Position = UDim2.fromOffset(226 - 10 - 56, ROW_H / 2 + 14), Size = UDim2.fromOffset(56, 50),
					BackgroundColor3 = C.field, BorderSizePixel = 0, Visible = false, ZIndex = 15,
				}, row)
				corner(ddList, 6)
				stroke(ddList, C.stroke, 1)
				local ddOpts = {}
				for n, pos in ipairs({ "Top", "Bottom" }) do
					local ob = new("TextButton", {
						Position = UDim2.fromOffset(2, 2 + (n - 1) * 23), Size = UDim2.fromOffset(52, 22),
						BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Text = "",
						AutoButtonColor = false, ZIndex = 16,
					}, ddList)
					corner(ob, 5)
					local ol = label(ob, "", 10, UDim2.fromOffset(8, 0), UDim2.fromOffset(40, 22), C.text, Enum.Font.GothamMedium)
					ol.ZIndex = 17
					ddOpts[pos] = { ob = ob, ol = ol }
					ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.88 end)
					ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 1 end)
					ob.MouseButton1Click:Connect(function()
						V.snapPos = pos
						ddList.Visible = false
						refreshDD()
						render()
					end)
				end
				refreshDD = function()
					ddLbl.Text = S(V.snapPos == "Top" and "snapTop" or "snapBottom")
					for pos, o in pairs(ddOpts) do
						o.ol.Text = S(pos == "Top" and "snapTop" or "snapBottom")
						o.ol.TextColor3 = (V.snapPos == pos) and C.text or C.muted
					end
				end
				refreshDD()
				onLang[#onLang + 1] = refreshDD
				ddBtn.MouseEnter:Connect(function() tween(ddSt, 0.15, { Color = Color3.fromRGB(120, 120, 140) }) end)
				ddBtn.MouseLeave:Connect(function() tween(ddSt, 0.15, { Color = C.stroke }) end)
				ddBtn.MouseButton1Click:Connect(function() ddList.Visible = not ddList.Visible end)
			end
			local lbl = reg(label(row, "", 12, UDim2.fromOffset(46, 0), UDim2.fromOffset((k == "snaplines") and 108 or 172, ROW_H), C.text, Enum.Font.GothamMedium), tk)
			lbl.TextTruncate = Enum.TextTruncate.AtEnd
			local btn = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, row)
			btn.MouseEnter:Connect(function() if not V[k] then tween(cboxSt, 0.15, { Color = Color3.fromRGB(110, 110, 130) }) end end)
			btn.MouseLeave:Connect(function() if not V[k] then tween(cboxSt, 0.15, { Color = BOX_OFF_STROKE }) end end)
			rows[k] = {
				lbl = lbl,
				set = function(on)
					tween(cbox, 0.18, { BackgroundColor3 = on and ACCENT or BOX_OFF })
					tween(cboxSt, 0.18, { Color = on and ACCENT or BOX_OFF_STROKE })
					tween(markScale, 0.22, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
				end,
			}
			btn.MouseButton1Click:Connect(function() V[k] = not V[k]; render() end)
		end
		render()
		local pgAdvanced = new("Frame", {
			Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = false,
		}, pgF)
		subPagesV[2] = pgAdvanced
		
		local secTitle = reg(label(pgAdvanced, "", 11, UDim2.fromOffset(0, 0), UDim2.fromOffset(446, 16), C.muted, Enum.Font.GothamBold), "secSystemCat")
		secTitle.Font = Enum.Font.Jura
		secTitle.TextSize = 13
		secTitle.TextColor3 = C.text
		
		local advCard = new("Frame", {
			Position = UDim2.fromOffset(0, 22), Size = UDim2.fromOffset(446, 64),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pgAdvanced)
		corner(advCard, 10)
		stroke(advCard, C.stroke, 1)
		reg(label(advCard, "", 12, UDim2.fromOffset(48, 11), UDim2.fromOffset(380, 18), C.text, Enum.Font.GothamBold), "adminAlertTitle")
		reg(label(advCard, "", 10, UDim2.fromOffset(48, 33), UDim2.fromOffset(380, 22), C.muted, Enum.Font.Gotham), "adminAlertDesc")
		local advCbox = new("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
			Size = UDim2.fromOffset(22, 22), BackgroundColor3 = V.adminAlert and ACCENT or BOX_OFF, BorderSizePixel = 0,
		}, advCard)
		corner(advCbox, 6)
		local advCboxSt = stroke(advCbox, V.adminAlert and ACCENT or BOX_OFF_STROKE, 1)
		local advMark = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
		}, advCbox)
		Icons.check(advMark, C.bg)
		local advMarkScale = new("UIScale", { Scale = V.adminAlert and 1 or 0 }, advMark)
		refreshAdminUI = function()
			local on = V.adminAlert
			tween(advCbox, 0.18, { BackgroundColor3 = on and ACCENT or BOX_OFF })
			tween(advCboxSt, 0.18, { Color = on and ACCENT or BOX_OFF_STROKE })
			tween(advMarkScale, 0.22, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
		end
		local advBtn = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, advCard)
		advBtn.MouseEnter:Connect(function() if not V.adminAlert then tween(advCboxSt, 0.15, { Color = Color3.fromRGB(110, 110, 130) }) end end)
		advBtn.MouseLeave:Connect(function() if not V.adminAlert then tween(advCboxSt, 0.15, { Color = BOX_OFF_STROKE }) end end)
		advBtn.MouseButton1Click:Connect(function()
			V.adminAlert = not V.adminAlert
			refreshAdminUI()
		end)

		local espTitle = reg(label(pgAdvanced, "", 11, UDim2.fromOffset(0, 96), UDim2.fromOffset(446, 16), C.muted, Enum.Font.GothamBold), "advancedEspCat")
		espTitle.Font = Enum.Font.Jura
		espTitle.TextSize = 13
		espTitle.TextColor3 = C.text

		local sliderCard = new("Frame", {
			Position = UDim2.fromOffset(0, 118), Size = UDim2.fromOffset(446, 60),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pgAdvanced)
		corner(sliderCard, 10)
		stroke(sliderCard, C.stroke, 1)

		reg(label(sliderCard, "", 13, UDim2.fromOffset(14, 10), UDim2.fromOffset(250, 20), C.text, Enum.Font.GothamBold), "espMaxDist")
		local sliderValLbl = label(sliderCard, V.maxDistance .. " m", 13, UDim2.fromOffset(332, 10), UDim2.fromOffset(100, 20), Color3.new(1, 1, 1), Enum.Font.GothamBold, Enum.TextXAlignment.Right)

		local sliderTrack = new("Frame", {
			Position = UDim2.fromOffset(14, 40), Size = UDim2.fromOffset(418, 4),
			BackgroundColor3 = Color3.fromRGB(35, 35, 44), BorderSizePixel = 0,
		}, sliderCard)
		corner(sliderTrack, 2)

		local sliderFill = new("Frame", {
			Position = UDim2.fromOffset(0, 0), Size = UDim2.new(V.maxDistance / 1000, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, sliderTrack)
		corner(sliderFill, 2)

		local sliderKnob = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(V.maxDistance / 1000, 0, 0.5, 0),
			Size = UDim2.fromOffset(10, 14), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, sliderTrack)
		corner(sliderKnob, 4)

		local sliderBtn = new("TextButton", {
			Position = UDim2.fromOffset(14, 32), Size = UDim2.fromOffset(418, 22),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
		}, sliderCard)

		local sliding = false
		local function updateSlider(input)
			local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
			local val = math.floor(pos * 1000)
			V.maxDistance = val
			sliderValLbl.Text = val .. " m"
			sliderFill.Size = UDim2.new(pos, 0, 1, 0)
			sliderKnob.Position = UDim2.new(pos, 0, 0.5, 0)
		end

		syncMaxDistUI = function()
			local val = math.clamp(V.maxDistance, 0, 1000)
			sliderValLbl.Text = val .. " m"
			sliderFill.Size = UDim2.new(val / 1000, 0, 1, 0)
			sliderKnob.Position = UDim2.new(val / 1000, 0, 0.5, 0)
		end

		sliderBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				sliding = true
				updateSlider(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				updateSlider(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				sliding = false
			end
		end)

		local t0, lastCount = os.clock(), 0
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not hub or not hub.Parent then conn:Disconnect() return end
			if not (pgF.Visible and hub.Visible) then return end
			local t = os.clock() - t0
			place(math.sin(t * 0.9) * 0.45)
			local currentDist = math.floor(24 + 9 * math.sin(t * 0.7))
			distLbl.Text = currentDist .. "m"
			distBgPrev.Position = UDim2.fromOffset(CXb - 22, by1 + 6)
			distBgPrev.Size = UDim2.fromOffset(44, 14)
			local currentWeapY = by1 + 6 + (V.distance and 16 or 0)
			weaponLbl.Position = UDim2.fromOffset(CXb - 70, currentWeapY)
			weapBgPrev.Position = UDim2.fromOffset(CXb - 35, currentWeapY)
			weapBgPrev.Size = UDim2.fromOffset(70, 14)
			local hp = 78 + 22 * math.sin(t * 0.8)
			local pct = hp / 100
			hClip.Size = UDim2.fromScale(1, pct)
			hNum.Text = tostring(math.floor(hp + 0.5))
			local numY = math.clamp(by0 + BOXH * (1 - pct), by0, by1 - 4)
			local ap = 0.72 + 0.2 * math.sin(t * 0.6 + 1.2)
			aClip.Size = UDim2.fromScale(1, ap)
			aNum.Text = tostring(math.floor(ap * 100 + 0.5))
			local anumY = math.clamp(by0 + BOXH * (1 - ap), by0, by1 - 6)
			if math.abs(anumY - numY) < 11 then anumY = math.clamp(numY + 11, by0, by1 + 6) end
			hNum.Position = UDim2.fromOffset(bx0 - 16, numY)
			aNum.Position = UDim2.fromOffset(bx0 - 16, anumY)
			local headPartM = model:FindFirstChild("Head")
			if headPartM then
				local hx, hy, hon = projectVF(cam, headPartM.Position, BW, BH)
				local thx, thy, thon = projectVF(cam, headPartM.Position + Vector3.new(0, 0.6, 0), BW, BH)
				local bhx, bhy, bhon = projectVF(cam, headPartM.Position - Vector3.new(0, 0.6, 0), BW, BH)
				-- Même logique que l'ESP : hauteur projetée, plafonnée à 45% de la largeur de la boîte, masqué sous 2 px
				local diam = math.min(math.abs(bhy - thy), BOXW * 0.45)
				if hon and thon and bhon and diam >= 2 then
					previewHeadCircle.Position = UDim2.fromOffset(hx, hy)
					previewHeadCircle.Size = UDim2.fromOffset(diam, diam)
					previewHeadCircle.Visible = true
				else
					previewHeadCircle.Visible = false
				end
			else
				previewHeadCircle.Visible = false
			end
			local pts = getSkeletonPoints(model)
			local shownP = {}
			for name, pos in pairs(pts) do
				local px, py, ok = projectVF(cam, pos, BW, BH)
				shownP[name] = { pos = Vector2.new(px, py), visible = ok }
			end
			for i = 1, #previewBones do
				local ln = previewBones[i]
				local sh = previewBoneShadows[i]
				local boneData = SKELETON_BONES[i]
				local j1 = boneData and shownP[boneData[1]]
				local j2 = boneData and shownP[boneData[2]]
				if j1 and j2 and j1.visible and j2.visible then
					setBoneLine(ln, sh, j1.pos.X, j1.pos.Y, j2.pos.X, j2.pos.Y, 2.2)
				else
					ln.Visible = false
					if sh then sh.Visible = false end
				end
			end
			if t - lastCount > 1 then lastCount = t; updateCount() end
		end)
	end
	visualsPage()
	comingSoon("catAssist")
	comingSoon("catPlayer")
	comingSoon("catFarm")
	miscPage()
	customPage()
	local current
	local tabBtns, tabPads, tabIcons, tabScales = {}, {}, {}, {}
	local function showTab(k)
		if current == k then return end
		local dir = (current and k < current) and -1 or 1
		for i, pgT in ipairs(pages) do
			if i == k then
				local isCG = pgT:IsA("CanvasGroup")
				pgT.Visible = true
				if isCG then pgT.GroupTransparency = 1 end
				pgT.Position = UDim2.fromOffset(180, 72 + 16 * dir)
				tween(pgT, 0.4, isCG and { GroupTransparency = 0, Position = UDim2.fromOffset(180, 72) } or { Position = UDim2.fromOffset(180, 72) }, Enum.EasingStyle.Quint)
			else
				pgT.Visible = false
			end
		end
		tween(pill, 0.35, { Position = UDim2.fromOffset(0, (k - 1) * 36) }, Enum.EasingStyle.Back)
		for j, b in ipairs(tabBtns) do
			local sel = (j == k)
			tween(b, 0.2, { TextColor3 = sel and C.text or TXT_OFF })
			tween(tabPads[j], 0.35, { PaddingLeft = UDim.new(0, sel and 46 or 16) }, Enum.EasingStyle.Back)
			if sel then
				tabIcons[j].Rotation = -70
				tabScales[j].Scale = 0
				tween(tabScales[j], 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
				tween(tabIcons[j], 0.45, { Rotation = 0 }, Enum.EasingStyle.Back)
			elseif tabScales[j].Scale > 0 then
				tween(tabScales[j], 0.2, { Scale = 0 })
			end
		end
		current = k
	end
	for i, cat in ipairs(cats) do
		local rowY = (i - 1) * 36
		local ico = cat.icon(side, 0, 0, ACCENT, C.panel)
		ico.AnchorPoint = Vector2.new(0.5, 0.5)
		ico.Position = UDim2.fromOffset(25, rowY + 18)
		ico.ZIndex = 3
		for _, d in ipairs(ico:GetDescendants()) do if d:IsA("GuiObject") then d.ZIndex = 3 end end
		tabScales[i] = new("UIScale", { Scale = 0 }, ico)
		tabIcons[i] = ico
		local b = new("TextButton", {
			Position = UDim2.fromOffset(-24, rowY), Size = UDim2.fromOffset(150, 36), BackgroundTransparency = 1,
			Text = "", Font = CAT_FONT, TextSize = 14, TextColor3 = TXT_OFF,
			TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 2,
			TextTransparency = 1,
		}, side)
		reg(b, cat.key)
		tabPads[i] = new("UIPadding", { PaddingLeft = UDim.new(0, 16) }, b)
		tabBtns[i] = b
		task.delay(0.35 + i * 0.07, function()
			tween(b, 0.5, { Position = UDim2.fromOffset(0, rowY), TextTransparency = 0 }, Enum.EasingStyle.Back)
		end)
		b.MouseEnter:Connect(function()
			if current ~= i then
				tween(b, 0.15, { TextColor3 = TXT_HOVER })
				tween(tabPads[i], 0.2, { PaddingLeft = UDim.new(0, 22) })
			end
		end)
		b.MouseLeave:Connect(function()
			if current ~= i then
				tween(b, 0.15, { TextColor3 = TXT_OFF })
				tween(tabPads[i], 0.2, { PaddingLeft = UDim.new(0, 16) })
			end
		end)
		b.MouseButton1Click:Connect(function() showTab(i) end)
	end
	local rankText = tostring(rank or "Standard")
	rankText = string.upper(string.sub(rankText, 1, 1)) .. string.sub(rankText, 2)
	local rk = string.lower(rankText)
	local theme = rankTheme(rk)
	local nameLbl = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 322), Size = UDim2.fromOffset(148, 20),
		Text = username, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, TextTransparency = 1,
	}, hub)
	local rankLbl = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 344), Size = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.X, Text = rankText, Font = Enum.Font.GothamBlack, TextSize = 14,
		TextColor3 = Color3.new(1, 1, 1), TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
	}, hub)
	applyRankShine(rankLbl, theme)

	local exp = makeExpiry(hub, UDim2.fromOffset(16, 368), 148, 16, 11)
	exp.root.Visible = false

	for n, lbl in ipairs({ nameLbl, rankLbl }) do
		local final = lbl.Position
		lbl.Position = UDim2.new(final.X.Scale, final.X.Offset - 14, final.Y.Scale, final.Y.Offset)
		task.delay(0.75 + n * 0.12, function()
			tween(lbl, 0.55, { Position = final, TextTransparency = 0 }, Enum.EasingStyle.Back)
		end)
	end
	task.delay(1.2, function()
		if exp.root and exp.root.Parent then
			exp.root.Position = UDim2.fromOffset(2, 368)
			exp.root.Visible = true
			tween(exp.root, 0.55, { Position = UDim2.fromOffset(16, 368) }, Enum.EasingStyle.Back)
		end
	end)

	applyLang = function()
		for _, r in ipairs(trList) do r.lbl.Text = S(r.key) end
		for _, f in ipairs(onLang) do f() end
		if adminTitleLenLbl then
			adminTitleLenLbl.Text = S("adminAlertTitle")
		end
		local life = isLifetimeVal(expires)
		local prefixKey = (not life) and "expiresOn" or "expiresAt"
		exp.set(S(prefixKey), expires)
	end
	applyLang()
	local hubOpen = true
	local kWrap = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 64, 0.5, -40),
		Size = UDim2.fromOffset(64, 64), BackgroundTransparency = 1, ZIndex = 80,
	}, gui)
	-- Le K flottant ne suit ni la palette "Apply Changes" ni "Rainbow Menu" : seul "Change Logo" le modifie
	kWrap:SetAttribute("NoTheme", true)
	local kScale = new("UIScale", { Scale = 0 }, kWrap)
	local kFloat = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 81 }, kWrap)
	local kMain -- K principal (jamais l'ombre) : cible du style "Change Logo"
	if IconAssets.k then
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 3), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, Image = IconAssets.k, ImageColor3 = Color3.new(0, 0, 0),
			ImageTransparency = 0.55, ScaleType = Enum.ScaleType.Fit, ZIndex = 80,
		}, kFloat)
		kMain = new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, Image = IconAssets.k, ScaleType = Enum.ScaleType.Fit, ZIndex = 82,
		}, kFloat)
	else
		kMain = new("TextLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "K", Font = Enum.Font.GothamBlack,
			TextScaled = true, TextColor3 = Color3.fromRGB(240, 240, 245), ZIndex = 82,
		}, kFloat)
	end
	-- Même dégradé brillant animé que le logo de l'en-tête (logoSequence + shine), appliqué uniquement au K principal
	do
		local kGrad
		local function kSequence(st)
			local W = Color3.new(1, 1, 1)
			return ColorSequence.new({
				ColorSequenceKeypoint.new(0, st.base),
				ColorSequenceKeypoint.new(0.3, st.light),
				ColorSequenceKeypoint.new(0.45, W),
				ColorSequenceKeypoint.new(0.55, W),
				ColorSequenceKeypoint.new(0.7, st.light),
				ColorSequenceKeypoint.new(1, st.base),
			})
		end
		applyKLogoStyle = function(st)
			if not kMain or not kMain.Parent then return end
			if st and st.base then
				if not kGrad or not kGrad.Parent then
					kGrad = new("UIGradient", {}, kMain)
					kGrad.Name = "KLogoGrad"
				end
				kGrad.Color = kSequence(st)
				kGrad.Rotation = 20
			else
				if kGrad then
					kGrad:Destroy()
					kGrad = nil
				end
			end
		end
		task.spawn(function()
			while kWrap and kWrap.Parent do
				if kGrad and kGrad.Parent then
					kGrad.Offset = Vector2.new(-1, 0)
					tween(kGrad, 1.2, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				end
				task.wait(2.6)
			end
		end)
	end
	local kBtn = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 90 }, kWrap)
	task.spawn(function()
		local t = 0
		while kWrap and kWrap.Parent do
			t = t + (task.wait())
			kFloat.Position = UDim2.fromOffset(0, math.sin(t * 2) * 3)
			kFloat.Rotation = math.sin(t * 1.3) * 3
		end
	end)
	setHub = function(open)
		if open == hubOpen then return end
		hubOpen = open
		kScale.Scale = 0.8
		tween(kScale, 0.4, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		if open then
			hub.Visible = true
			hub.Size = UDim2.fromOffset(0, 0)
			tween(hub, 0.55, { Size = UDim2.fromOffset(640, 400) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		else
			tween(hub, 0.35, { Size = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			task.delay(0.38, function() if not hubOpen then hub.Visible = false end end)
		end
	end
	kBtn.MouseEnter:Connect(function() tween(kScale, 0.2, { Scale = 1.12 }, Enum.EasingStyle.Back) end)
	kBtn.MouseLeave:Connect(function() tween(kScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)
	do
		local dragging, moved, startMouse, startPos = false, false, nil, nil
		kBtn.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging, moved, startMouse, startPos = true, false, i.Position, kWrap.Position
				tween(kScale, 0.1, { Scale = 0.9 })
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - startMouse
				if d.Magnitude > 6 then moved = true end
				if moved then kWrap.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
				tween(kScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back)
				if not moved then setHub(not hubOpen) end
			end
		end)
	end
	task.delay(0.9, function() tween(kScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end)
	showTab(1)
	tween(hub, 0.6, { Size = UDim2.fromOffset(640, 400) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

---------------------------------------------------------------------
-- ÉCRAN DE CHARGEMENT ET LANCEMENT DU HUB
---------------------------------------------------------------------
local function openMainDashboard(username, rank, expires, expiresAt)
	if gui:FindFirstChild("KryptonDashboard") then return end
	local W, H = 560, 392
	local CX, CY = W / 2, 130
	local mainWin = new("Frame", {
		Name = "KryptonDashboard",
		Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 50,
	}, gui)
	corner(mainWin, 14)
	stroke(mainWin, C.stroke, 1, 0.2)
	local sc = new("UIScale", {}, mainWin)
	local function us()
		local v = gui.AbsoluteSize
		sc.Scale = math.clamp(math.min(v.X / 640, v.Y / 520), 0.4, 1)
	end
	us()
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(us)
	makeParticles(mainWin, W, H, 12)
	local topDrag = new("Frame", { Size = UDim2.fromOffset(W, 56), BackgroundTransparency = 1 }, mainWin)
	makeDraggable(mainWin, topDrag)
	local rankText = tostring(rank or "Standard")
	rankText = string.upper(string.sub(rankText, 1, 1)) .. string.sub(rankText, 2)
	local rk = string.lower(rankText)
	local rankCol = Color3.fromRGB(255, 235, 130)
	if rk == "free" then rankCol = Color3.fromRGB(135, 210, 255)
	elseif rk == "standard" then rankCol = Color3.fromRGB(140, 240, 165) end
	local card = new("Frame", {
		Position = UDim2.fromOffset(16, -110), Size = UDim2.fromOffset(200, 96),
		BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 3,
	}, mainWin)
	corner(card, 10)
	stroke(card, C.stroke, 1)
	label(card, S("license"), 10, UDim2.fromOffset(14, 9), UDim2.fromOffset(80, 14), C.muted, Enum.Font.Gotham)
	applyRankShine(label(card, rankText, (#rankText > 9) and 9 or 14, UDim2.fromOffset(14, 23), UDim2.fromOffset(80, 20), rankCol, Enum.Font.GothamBlack), rankTheme(rk))
	label(card, S("expires"), 10, UDim2.fromOffset(104, 9), UDim2.fromOffset(84, 14), C.muted, Enum.Font.Gotham)
	makeExpiry(card, UDim2.fromOffset(104, 23), 84, 20, 13).set("", expires)
	new("Frame", { Position = UDim2.fromOffset(14, 49), Size = UDim2.fromOffset(172, 1), BackgroundColor3 = C.stroke, BorderSizePixel = 0 }, card)
	local gDot = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 71),
		Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.muted, BorderSizePixel = 0,
	}, card)
	new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, gDot)
	local gLbl = label(card, "...", 12, UDim2.fromOffset(30, 62), UDim2.fromOffset(160, 18), C.text, Enum.Font.GothamMedium)
	gLbl.TextTruncate = Enum.TextTruncate.AtEnd
	task.spawn(function()
		local name = getGameName()
		if gLbl and gLbl.Parent then gLbl.Text = name end
		if gDot and gDot.Parent then tween(gDot, 0.3, { BackgroundColor3 = isGameSupported() and C.good or C.err }) end
	end)
	task.delay(0.4, function() tween(card, 0.6, { Position = UDim2.fromOffset(16, 26) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end)
	local glowD = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
		Size = UDim2.fromOffset(150, 150), BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.94, BorderSizePixel = 0,
	}, mainWin)
	new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, glowD)
	task.spawn(function()
		while mainWin and mainWin.Parent do
			tween(glowD, 1.5, { BackgroundTransparency = 0.88, Size = UDim2.fromOffset(172, 172) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.5)
			tween(glowD, 1.5, { BackgroundTransparency = 0.96, Size = UDim2.fromOffset(146, 146) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.5)
		end
	end)
	local logo = makeLogo(mainWin, 116, UDim2.fromOffset(CX, CY), Vector2.new(0.5, 0.5))
	local logoScale = new("UIScale", { Scale = 0 }, logo)
	task.delay(0.3, function() tween(logoScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end)
	task.spawn(function()
		local t = 0
		while mainWin and mainWin.Parent do
			t = t + (task.wait())
			logo.Position = UDim2.fromOffset(CX, CY + math.sin(t * 2) * 4)
			logo.Rotation = math.sin(t * 1.5) * 2
		end
	end)
	local ringBase = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
		Size = UDim2.fromOffset(152, 152), BackgroundTransparency = 1,
	}, mainWin)
	corner(ringBase, 76)
	stroke(ringBase, C.stroke, 1, 0.2)
	local spin = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
		Size = UDim2.fromOffset(152, 152), BackgroundTransparency = 1,
	}, mainWin)
	corner(spin, 76)
	local spinStroke = stroke(spin, Color3.new(1, 1, 1), 2.5, 0)
	local spinGrad = new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 1),
			NumberSequenceKeypoint.new(0.8, 0.4), NumberSequenceKeypoint.new(1, 0),
		}),
	}, spinStroke)
	task.spawn(function()
		while mainWin and mainWin.Parent do
			local dt = task.wait()
			spinGrad.Rotation = (spinGrad.Rotation + dt * 300) % 360
		end
	end)
	local pLbl = label(mainWin, S("dashLoading"), 12, UDim2.fromOffset(60, 220), UDim2.fromOffset(W - 180, 18), C.text, Enum.Font.GothamMedium)
	local pctLbl = label(mainWin, "0%", 12, UDim2.fromOffset(W - 120, 220), UDim2.fromOffset(60, 18), C.muted, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	local track = new("Frame", {
		Position = UDim2.fromOffset(60, 244), Size = UDim2.fromOffset(W - 120, 6),
		BackgroundColor3 = C.field, BorderSizePixel = 0, ZIndex = 2, ClipsDescendants = true,
	}, mainWin)
	corner(track, 3)
	local fill = new("Frame", {
		Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		ZIndex = 3, ClipsDescendants = true,
	}, track)
	corner(fill, 3)
	local fillShine = new("Frame", {
		Position = UDim2.new(-0.4, 0, 0, 0), Size = UDim2.new(0.4, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(160, 160, 175), BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 4,
	}, fill)
	new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
		}),
	}, fillShine)
	task.spawn(function()
		while mainWin and mainWin.Parent do
			fillShine.Position = UDim2.new(-0.4, 0, 0, 0)
			tween(fillShine, 0.9, { Position = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.3)
		end
	end)
	local loaderConn
	loaderConn = RunService.RenderStepped:Connect(function()
		if not mainWin or not mainWin.Parent then if loaderConn then loaderConn:Disconnect() end return end
		local trackW = track.AbsoluteSize.X
		local fillW = fill.AbsoluteSize.X
		if trackW > 0 then
			local ratio = math.clamp(fillW / trackW, 0, 1)
			pctLbl.Text = math.floor(ratio * 100 + 0.5) .. "%"
		end
	end)
	local steps = { S("stepLicense"), S("stepGame"), S("stepMenu") }
	local stepItems = {}
	local sw = (W - 120) / #steps
	for i, name in ipairs(steps) do
		local x = 60 + (i - 1) * sw
		local dotF = new("Frame", {
			Position = UDim2.fromOffset(x, 267), Size = UDim2.fromOffset(10, 10),
			BackgroundColor3 = C.field, BorderSizePixel = 0, ZIndex = 3,
		}, mainWin)
		corner(dotF, 5)
		local dst = stroke(dotF, C.stroke, 1)
		local lbl = label(mainWin, name, 10, UDim2.fromOffset(x + 16, 262), UDim2.fromOffset(sw - 20, 20), C.muted, Enum.Font.GothamMedium)
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		stepItems[i] = { dot = dotF, st = dst, lbl = lbl }
	end
	local function stepState(i, done)
		local it = stepItems[i]
		local col = done and C.good or Color3.new(1, 1, 1)
		tween(it.dot, 0.25, { BackgroundColor3 = col })
		tween(it.st, 0.25, { Color = col })
		tween(it.lbl, 0.25, { TextColor3 = C.text })
	end
	local chips = {
		{ S("lblUser"), tostring(username) },
		{ S("expires"), expiresText(expires) },
		{ S("lblDEVICE"), deviceId() },
	}
	local GAP = 8
	local cw = (W - 32 - GAP * (#chips - 1)) / #chips
	local chipY = H - 66
	for i, c in ipairs(chips) do
		local x = 16 + (i - 1) * (cw + GAP)
		local chip = new("Frame", {
			Position = UDim2.fromOffset(x, H + 10), Size = UDim2.fromOffset(cw, 50),
			BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 3,
		}, mainWin)
		corner(chip, 8)
		stroke(chip, C.stroke, 1)
		label(chip, c[1], 9, UDim2.fromOffset(10, 8), UDim2.fromOffset(cw - 20, 12), C.muted, Enum.Font.Gotham)
		local v = label(chip, c[2], 12, UDim2.fromOffset(10, 23), UDim2.fromOffset(cw - 20, 20), C.text, Enum.Font.GothamBold)
		if i == 2 then
			v.Visible = false
			makeExpiry(chip, UDim2.fromOffset(10, 23), cw - 20, 20, 12).set("", expires)
		else
			v.TextTruncate = Enum.TextTruncate.AtEnd
		end
		task.delay(0.8 + i * 0.1, function()
			if chip and chip.Parent then
				tween(chip, 0.55, { Position = UDim2.fromOffset(x, chipY) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end
		end)
	end
	task.delay(0.9, function()
		for i, name in ipairs(steps) do
			if not mainWin or not mainWin.Parent then return end
			pLbl.Text = name
			stepState(i, false)
			tween(fill, 0.7, { Size = UDim2.new(i / #steps, 0, 1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(0.85)
			stepState(i, true)
		end
		if not mainWin or not mainWin.Parent then return end
		pLbl.Text = S("dashReady")
		pLbl.TextColor3 = C.good
		pctLbl.Text = "100%"
		pctLbl.TextColor3 = C.good
		tween(fill, 0.4, { BackgroundColor3 = C.good })
		if loaderConn then loaderConn:Disconnect() end
		local burst = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
			Size = UDim2.fromOffset(152, 152), BackgroundTransparency = 1,
		}, mainWin)
		corner(burst, 300)
		local bs = stroke(burst, C.good, 2, 0.1)
		tween(burst, 0.8, { Size = UDim2.fromOffset(460, 460) })
		tween(bs, 0.8, { Transparency = 1 })
		task.wait(0.8)
		tween(mainWin, 0.4, { Size = UDim2.fromOffset(W, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.wait(0.45)
		mainWin:Destroy()
		openHub(username, rank, expires, expiresAt)
	end)
	tween(mainWin, 0.6, { Size = UDim2.fromOffset(W, H) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

---------------------------------------------------------------------
-- AUTHENTIFICATION API
---------------------------------------------------------------------
local ERROR_MAP = {
	taken = "userTaken", user_taken = "userTaken", exists = "userTaken", username_taken = "userTaken",
	no_account = "noAccount", not_found = "noAccount", unknown_user = "noAccount",
	bad_credentials = "badCreds", wrong_password = "badCreds", invalid_credentials = "badCreds",
	account_expired = "expired",
	hwid_mismatch = "hwid", hwid_locked = "hwid",
	rate_limited = "rate", too_many_requests = "rate",
}

local function mapError(code, signup)
	code = tostring(code or "invalid")
	if ERROR_MAP[code] then return ERROR_MAP[code] end
	if code == "invalid" then return "badCreds" end
	if Lang.EN[code] then return code end
	return "errServer"
end

local function authRequest(mode, username, password)
	if not globalRequest then return { valid = false, error = "noRequest" } end
	local path = (mode == "signup") and Config.RegisterPath or Config.LoginPath
	local response = httpJson(path, { username = username, password = password, hwid = deviceId() }, 8, 5)
	if not response then return { valid = false, error = "errServer" } end
	local data = response
	if type(response) == "table" and #response > 0 then data = response[1] end
	if type(data) ~= "table" then return { valid = false, error = "errServer" } end
	if data.valid == true or data.ok == true or data.success == true then
		local exp = data.expires
		if exp == nil then exp = "Lifetime" end
		local expAt = (type(data.expiresAt) == "number") and data.expiresAt or nil
		return { valid = true, rank = data.rank or "Standard", expires = exp, expiresAt = expAt }
	end
	return { valid = false, error = mapError(data.error, mode == "signup") }
end

local function checkSavedKey()
	local success, content = pcall(function()
		if isfile and isfile(Config.KeyFile) and readfile then return readfile(Config.KeyFile) end
	end)
	if success and content then
		local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
		if ok and type(data) == "table" then
			if data.Remember == false then setRemember(false, true)
			else
				if data.Username then userBox.Text = data.Username end
				if data.Password then passBox.Text = data.Password end
			end
		end
	end
end

---------------------------------------------------------------------
-- LOGIQUE INTERFACE & LANGUES
---------------------------------------------------------------------
local statusKey
local function setStatus(key, good)
	statusKey = key
	status.TextColor3 = good and C.good or C.err
	status.Text = key and S(key) or ""
	if key then
		status.Position = UDim2.fromOffset(0, Y_STATUS + 4)
		status.TextTransparency = 1
		tween(status, 0.3, { Position = UDim2.fromOffset(0, Y_STATUS), TextTransparency = 0 }, Enum.EasingStyle.Back)
	end
end

discordBtn.MouseButton1Click:Connect(function() openDiscord(); setStatus("copied", true) end)
getKeyBtn.MouseButton1Click:Connect(function() openDiscord(); setStatus("copied", true) end)

local firstRefresh = true
local function refresh()
	if firstRefresh then
		typeText(title, isSignup and S("signup") or S("welcome"))
		typeText(subtitle, isSignup and S("subSignup") or S("sub"))
		firstRefresh = false
	else
		title.Text = isSignup and S("signup") or S("welcome")
		subtitle.Text = isSignup and S("subSignup") or S("sub")
	end
	submitText.Text = isSignup and S("signup") or S("signin")
	getKeyText.Text = S("getKeyBtn")
	userBox.PlaceholderText = S("userPh")
	for _, f in ipairs(maskUpdaters) do f() end
	rememberLbl.Text = S("remember")
	updateGameBadge()
	tabSignin.Text = S("signin")
	tabSignup.Text = S("signup")
	if statusKey then status.Text = S(statusKey) end
	tween(tabPill, 0.35, { Position = UDim2.fromOffset(isSignup and 153 or 3, 3) }, Enum.EasingStyle.Back)
	tabSignin.TextColor3 = not isSignup and C.text or C.muted
	tabSignup.TextColor3 = isSignup and C.text or C.muted
	if isSignup and not getKeyBtn.Visible then
		getKeyBtn.Position = UDim2.fromOffset(0, Y_GETKEY + 20)
		getKeyBtn.Visible = true
		tween(getKeyBtn, 0.45, { Position = UDim2.fromOffset(0, Y_GETKEY) }, Enum.EasingStyle.Back)
	elseif not isSignup then
		getKeyBtn.Visible = false
	end
	for code, b in pairs(langBtns) do
		local on = code == currentLang
		b.TextColor3 = on and C.text or C.muted
		tween(langStrokes[code], 0.2, { Color = on and C.text or C.stroke })
	end
end

tabSignin.MouseButton1Click:Connect(function() isSignup = false; setStatus(nil); refresh() end)
tabSignup.MouseButton1Click:Connect(function() isSignup = true; setStatus(nil); refresh() end)

for code, b in pairs(langBtns) do
	b.MouseButton1Click:Connect(function() currentLang = code; saveLang(); refresh() end)
end

local function flashError(...)
	local sts = { ... }
	if #sts == 0 then sts = { userStroke, passStroke } end
	for _, st in ipairs(sts) do
		tween(st, 0.15, { Color = C.err })
		task.delay(0.8, function() tween(st, 0.3, { Color = C.stroke }) end)
	end
end

local working = false
local function doSubmit()
	if working then return end
	if not globalRequest then flashError(); return setStatus("noRequest") end
	local enteredUser = userBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	local enteredPass = passBox.Text
	if enteredUser == "" then flashError(userStroke); return setStatus("emptyUser") end
	if enteredPass == "" then flashError(passStroke); return setStatus("emptyPass") end
	if isSignup and #enteredPass < 4 then flashError(passStroke); return setStatus("shortPass") end
	working = true
	setStatus(nil)
	submitText.Text = S("verifying")
	task.spawn(function()
		local base = S("verifying"):gsub("%.+$", "")
		local d = 0
		while working do
			submitText.Text = base .. string.rep(".", d)
			d = (d + 1) % 4
			task.wait(0.3)
		end
	end)
	task.spawn(function()
		local res = authRequest(isSignup and "signup" or "signin", enteredUser, enteredPass)
		working = false
		if res.valid then
			Session.password = enteredPass
			if writefile then
				pcall(function()
					if remember then
						writefile(Config.KeyFile, HttpService:JSONEncode({ Username = enteredUser, Password = enteredPass, Remember = true }))
					else
						writefile(Config.KeyFile, HttpService:JSONEncode({ Remember = false }))
					end
				end)
			end
			submitText.Text = S("granted") .. " ✓"
			tween(submit, 0.3, { BackgroundColor3 = C.good })
			setStatus("granted", true)
			task.wait(0.7)
			tween(window, 0.35, { Size = UDim2.fromOffset(744, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			task.wait(0.4)
			window:Destroy()
			openMainDashboard(enteredUser, res.rank, res.expires, res.expiresAt)
		else
			task.wait(0.35)
			submitText.Text = isSignup and S("signup") or S("signin")
			setStatus(res.error or "badCreds")
			flashError()
			local p = window.Position
			for _, dx in ipairs({ 8, -8, 6, -6, 3, -3, 0 }) do
				window.Position = UDim2.new(p.X.Scale, p.X.Offset + dx, p.Y.Scale, p.Y.Offset)
				task.wait(0.02)
			end
		end
	end)
end

submit.MouseButton1Click:Connect(doSubmit)
passBox.FocusLost:Connect(function(enter) if enter then doSubmit() end end)
userBox.FocusLost:Connect(function(enter) if enter then passBox:CaptureFocus() end end)

---------------------------------------------------------------------
-- INTRO
---------------------------------------------------------------------
local function slideIn(obj, delay)
	local final = obj.Position
	obj.Position = UDim2.new(final.X.Scale, final.X.Offset - 36, final.Y.Scale, final.Y.Offset)
	task.delay(delay, function() tween(obj, 0.5, { Position = final }, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end)
end

checkSavedKey()
refresh()
window.Size = UDim2.fromOffset(744, 0)
tween(window, 0.6, { Size = UDim2.fromOffset(744, 466) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

slideIn(title, 0.35)
slideIn(subtitle, 0.42)
slideIn(tabContainer, 0.5)
slideIn(userField, 0.58)
slideIn(passField, 0.66)
slideIn(rememberBtn, 0.74)
slideIn(submit, 0.82)
