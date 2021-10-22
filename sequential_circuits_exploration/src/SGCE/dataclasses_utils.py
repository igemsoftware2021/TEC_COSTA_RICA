from dataclasses import dataclass, field, replace, asdict, astuple, fields


def dataclass_from_dict(class_type, dict_input):
    try:

        fieldtypes = {f.name: f.type for f in fields(class_type)}
        available_fileds = set(
            dict_input.keys()).intersection(fieldtypes.keys())
        return class_type(**{f: dict_input[f] for f in available_fileds})
    except Exception as ex:
        return None
