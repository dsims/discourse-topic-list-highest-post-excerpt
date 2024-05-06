import { registerRawHelper } from 'discourse-common/lib/helpers';

registerRawHelper('isValidCategory', function(value) {
	const array = settings.categories.split("|")
		.map((id) => parseInt(id, 10))
		.filter((id) => id);

	return array.includes(value);
});