import React, { useState } from "react"
import { fetchNui } from "../utils/fetchNui"
import { useNuiEvent } from "../hooks/useNuiEvent"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import * as Icons from '@fortawesome/free-solid-svg-icons'
import { IconProp } from '@fortawesome/fontawesome-svg-core'

const Dialogue: React.FC = () => {
    const [options, setOptions] = useState([])
    const [label, setLabel] = useState('')
    const [speech, setSpeech] = useState('')
    
    useNuiEvent<any>('dialogue', (data) => {
        setOptions(data.options)
        setLabel(data.label)
        setSpeech(data.speech)
    })

    const getIconByName = (iconName: string) => {
        const formattedName = `fa${iconName.charAt(0).toUpperCase() + iconName.slice(1).replace(/-./g, (m) => m[1].toUpperCase())}`
        return Icons[formattedName as keyof typeof Icons] || Icons.faQuestionCircle
    }

    return (
        <div
            style={{
                width: '100%',
                height: '100%',
                margin: -8, 
                position: 'fixed',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'flex-end',
                fontFamily: "'Bai Jamjuree', sans-serif",
                userSelect: 'none',
            }}
        >
            <div
                style={{
                    width: '100%',
                    maxWidth: '1000px',
                    padding: '1rem',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '0.5rem',
                }}
            >
                {/* Name Label */}
                <div
                    style={{
                        backgroundColor: '#121a1cde',
                        border: '0.0625rem solid #c2f4f967',
                        borderRadius: '0.25rem',
                        padding: '0.75rem 1rem',
                        color: '#C2F4F9',
                        fontSize: '1.25rem',
                        fontWeight: 600,
                        width: 'fit-content',
                        display: 'inline-block',
                    }}
                >
                    {label}
                </div>

                {/* Speech Box */}
                <div
                    style={{
                        backgroundColor: '#121a1cde',
                        border: '0.0625rem solid #c2f4f967',
                        borderRadius: '0.25rem',
                        padding: '0.75rem 1rem',
                        color: '#fff',
                        fontSize: '1rem',
                        fontWeight: 400,
                    }}
                >
                    {speech}
                </div>

                {/* Options */}
                {options.length > 0 && (
                    <div
                        style={{
                            display: 'flex',
                            flexDirection: 'row',
                            justifyContent: 'flex-start',
                            flexWrap: 'wrap',
                            gap: '0.5rem',
                            marginTop: '0.5rem',
                        }}
                    >
                        {options.map(({ label: optionLabel, icon, id, close, canInteract }) => (
                            canInteract && (
                                <button
                                    key={id}
                                    onClick={() => fetchNui('executeAction', { id, options, close })}
                                    style={{
                                        backgroundColor: '#384f52cc',
                                        border: '0.0625rem solid #c2f4f967',
                                        borderRadius: '0.15rem',
                                        padding: '0.5rem 1rem',
                                        color: '#fff',
                                        fontSize: '0.9rem',
                                        fontWeight: 500,
                                        fontFamily: "'Bai Jamjuree', sans-serif",
                                        cursor: 'pointer',
                                        display: 'flex',
                                        alignItems: 'center',
                                        gap: '0.5rem',
                                        transition: 'all 0.2s ease',
                                    }}
                                    onMouseEnter={(e) => {
                                        e.currentTarget.style.backgroundColor = '#384f52e6'
                                        e.currentTarget.style.borderColor = '#c2f4f9'
                                    }}
                                    onMouseLeave={(e) => {
                                        e.currentTarget.style.backgroundColor = '#384f52cc'
                                        e.currentTarget.style.borderColor = '#c2f4f967'
                                    }}
                                >
                                    {icon && (
                                        <FontAwesomeIcon 
                                            icon={getIconByName(icon) as IconProp}
                                            style={{
                                                fontSize: '0.9rem',
                                                color: '#C2F4F9',
                                            }}
                                        />
                                    )}
                                    {optionLabel}
                                </button>
                            )
                        ))}
                    </div>
                )}
            </div>
        </div>
    )
}

export default Dialogue
