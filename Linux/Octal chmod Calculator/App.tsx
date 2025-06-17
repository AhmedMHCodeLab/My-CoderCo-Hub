
import React, { useState } from 'react';

// Constants
const SYMBOLIC_MAP = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'];
const OCTAL_REGEX = /^[0-7]$/;
const PERMISSION_VALUES = { read: 4, write: 2, execute: 1 } as const;

// Types
type PermissionField = 'owner' | 'group' | 'public';
type PermissionType = keyof typeof PERMISSION_VALUES;
type DigitsState = Record<PermissionField, string>;

// Components
const LockIcon = () => (
  <svg 
    xmlns="http://www.w3.org/2000/svg" 
    viewBox="0 0 20 20"
    fill="currentColor" 
    className="w-8 h-8"
  >
    <path 
      fillRule="evenodd" 
      d="M10 1a4.5 4.5 0 00-4.5 4.5V9H5a2 2 0 00-2 2v6a2 2 0 002 2h10a2 2 0 002-2v-6a2 2 0 00-2-2h-.5V5.5A4.5 4.5 0 0010 1zm3 8V5.5a3 3 0 10-6 0V9h6z" 
      clipRule="evenodd" 
    />
  </svg>
);

const App: React.FC = () => {
  const [digits, setDigits] = useState<DigitsState>({ 
    owner: '', 
    group: '', 
    public: '' 
  });

  // Utility functions
  const isValidOctalDigit = (digit: string): boolean => OCTAL_REGEX.test(digit);

  const calculateResults = () => {
    const nums = Object.values(digits).map(d => 
      isValidOctalDigit(d) ? Number(d) : 0
    );
    
    return {
      octal: `0${nums.join('')}`,
      symbolic: nums.map(n => SYMBOLIC_MAP[n]).join('')
    };
  };

  // Event handlers
  const handleInputChange = (field: PermissionField) => (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    const value = e.target.value;
    if (value === '' || isValidOctalDigit(value)) {
      setDigits(prev => ({ ...prev, [field]: value }));
    }
  };

  const handleCheckboxChange = (field: PermissionField, permission: PermissionType) => {
    const currentValue = parseInt(digits[field] || '0');
    const permissionValue = PERMISSION_VALUES[permission];
    const newValue = currentValue ^ permissionValue; // Toggle the bit
    
    setDigits(prev => ({ ...prev, [field]: newValue.toString() }));
  };

  const hasPermission = (field: PermissionField, permission: PermissionType): boolean => {
    const value = parseInt(digits[field] || '0');
    const permissionValue = PERMISSION_VALUES[permission];
    return (value & permissionValue) !== 0;
  };

  const getPermissionLabel = (permission: PermissionType): string => {
    const value = PERMISSION_VALUES[permission];
    const label = permission.charAt(0).toUpperCase() + permission.slice(1);
    return `${label} (${value})`;
  };

  // Render functions
  const renderInput = (field: PermissionField, label: string) => {
    const value = digits[field];
    const error = value && !isValidOctalDigit(value);
    
    return (
      <div className="flex-1">
        <label className="block text-sm font-medium text-gray-300 mb-1">
          {label}
        </label>
        <input
          type="text"
          value={value}
          onChange={handleInputChange(field)}
          maxLength={1}
          className={`
            mt-1 block w-full bg-gray-700 border rounded-md shadow-sm 
            py-3 px-4 text-center text-lg text-white
            focus:outline-none focus:ring-2 focus:border-transparent transition-colors
            ${error 
              ? 'border-red-500 focus:ring-red-500' 
              : 'border-gray-600 focus:ring-blue-500'
            }
          `}
          placeholder="0-7"
        />
        <div className="mt-2 space-y-1">
          {(['read', 'write', 'execute'] as const).map(permission => (
            <label key={permission} className="flex items-center text-xs text-gray-400">
              <input
                type="checkbox"
                checked={hasPermission(field, permission)}
                onChange={() => handleCheckboxChange(field, permission)}
                className="mr-2 w-3 h-3 text-blue-600 bg-gray-700 border-gray-600 rounded focus:ring-blue-500 focus:ring-2"
              />
              {getPermissionLabel(permission)}
            </label>
          ))}
        </div>
      </div>
    );
  };

  const renderResults = () => {
    const results = calculateResults();
    
    return (
      <div className="mt-6 p-6 bg-gray-700/50 rounded-lg shadow-inner space-y-4">
        <div>
          <h3 className="text-sm font-medium text-blue-300 mb-1">
            Octal Notation:
          </h3>
          <p className="text-2xl font-mono bg-gray-800 p-3 rounded text-center text-green-400 tracking-wider">
            {results.octal}
          </p>
        </div>
        <div>
          <h3 className="text-sm font-medium text-blue-300 mb-1">
            Symbolic Notation:
          </h3>
          <p className="text-2xl font-mono bg-gray-800 p-3 rounded text-center text-green-400 tracking-wider">
            {results.symbolic}
          </p>
        </div>
      </div>
    );
  };

  // Main render
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-gray-900 to-gray-800 p-4 text-gray-100 font-inter">
      <div className="w-full max-w-lg bg-gray-800/70 backdrop-blur-lg border border-gray-700/50 shadow-xl rounded-xl p-6 md:p-8 space-y-6 transition-all duration-500 hover:shadow-2xl hover:shadow-blue-500/30">
        
        {/* Header */}
        <div className="flex items-center justify-center space-x-2 text-2xl font-semibold text-blue-400">
          <LockIcon />
          <h1>Chmod Permission Calculator</h1>
        </div>

        {/* Input Fields */}
        <div className="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
          {renderInput('owner', 'Owner (User)')}
          {renderInput('group', 'Group')}
          {renderInput('public', 'Public (Others)')}
        </div>

        {/* Results */}
        {renderResults()}
        
      </div>
      
      {/* Footer */}
      <footer className="mt-12 text-center text-sm text-gray-500">
        <p>&copy; {new Date().getFullYear()} Chmod Calculator. Built By AhmedMHCodeLab.</p>
      </footer>
    </div>
  );
};

export default App;
