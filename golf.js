{
	_User: {},
	courses: {
		name: 'string'
	},
	rounds: {
		name: 'string',
		user: 'pointer',
		course: 'string',
		strokes: 'relation'
		date: 'date'
	},
	stokes: {
		user: 'pointer',
		round: 'pointer',
		course: 'string',
		hole: 'integer',
		par: 'integer',
		result: 'string',
		longitude: 'string'
		latitude: 'string'
	},
	list: {
		'gir/fir/puts',
		'club selection',
		'map',
		'group',
		'scorecard'
	}

	views: {
		login,
		signup,
		dashboard: {
			rounds: {
				round: {
					'name',
					course: {
						'course'
					},
					matchType: {
						'type'
					},
					leaderboard: {
						player: 'score',
						addPlayer: {}
					},
					scorecard: {
						holes: {
							'hole',
							map: {}
						}
					},
					map: {}
				}
			},
			settings: {
				accuracy,
				verify
				myaccount: {
					changeEmail,
					changePassword
				}
			}
		}
	}

}